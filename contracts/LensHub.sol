//SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import {ILensHub} from "./ILensHub.sol";
import {Events} from "./Events.sol";
import {Helpers} from "./Helpers.sol";
import {Constants} from "./Constants.sol";
import {DataTypes} from "./DataTypes.sol";
import {Errors} from "./Errors.sol";
import {PublishingLogic} from "./PublishingLogic.sol";
import {ProfileTokenURILogic} from "./ProfileTokenURILogic.sol";
import {InteractionLogic} from "./InteractionLogic.sol";
import {LensNFTBase} from "./base/LensNFTBase.sol";
import {LensMultiState} from "./base/LensMultiState.sol";
import {LensHubStorage} from "./storage/LensHubStorage.sol";
import {VersionedInitializable} from "../upgradeability/VersionedInitializable.sol";
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

/**
 * @title LensHub
 * @author Lens Protocol
 *
 * @notice This is the main entrypoint of the Lens Protocol. It contains goveranance functionality as well as
 * publishing and profile interaction functionality
 *
 *NOTE: The Lens protocol is uinwui in that frontend operators need to track a poatanially overwhielming
 * number of NFT contracts and interactions at once. for that reason, we've mad two qurky decsion
 *      1. Both Follow & Collect NFTs invoke an LensHub callback on transfer with sole purpose of emitting an event.
 *      2. Amosot every event in the protocol emits the current block times
 */

contract LensHub is
    LensNFTBase,
    VersionedInitializable,
    LensMultiState,
    LensHubStorage,
    ILensHub
{
    uint256 internal constant REVISION = 1;
    address internal immutable FOLLOW_NFT_IMPL;
    address internal immutable COLLECT_NFT_IMPL;

    /**
     * @dev this modifier reverts if the caller is not the configured goverenance address.
     *
     */

    modifier onlyGov() {
        _validateCallerIsGovernance();
        _;
    }

    /**
     * @dev The constructor sets the immutable follow & collect NFT implementations.
     *
     * @param followNFTImpl The follow NFT implementation address.
     * @param collectNFTImpl The collect NFT implementation address.
     */
    constructor(address followNFTImpl, address collectNFTImpl) {
        if (followNFTImpl == address(0)) revert Errors.InitParamsInvalid();
        if (collectNFTImpl == address(0)) revert Errors.InitParamsInvalid();
        FOLLOW_NFT_IMPL = followNFTImpl;
        COLLECT_NFT_IMPL = collectNFTImpl;
    }

    /// @inheritdoc ILensHub
    function initialize(
        string calldata name,
        string calldata symbol,
        address newGovernance,
    ) external override initializer{
        super._initialize(name, symbol);
        _setState(DataTypes.ProtocolState.Paused);
        _setGovernance(newGovernance);
    }

    /// ***************************
    /// *****GOVE FUNCTION*********
    /// ***************************

    /// @inheritdoc ILensHub
    function setGovernance(address newGovernance) external override onlyGov {
        _setGovernance(newGovernance);
    }

     /// @inheritdoc ILensHub
    function setEmergencyAdmin(address newEmergencyAdmin)
        external
        override
        onlyGov
    {
        address prevEmergencyAdmin = _emergencyAdmin;
        _emergencyAdmin = newEmergencyAdmin;
        emit Events.EmergencyAdminSet(
            msg.sender,
            prevEmergencyAdmin,
            newEmergencyAdmin,
            block.timestamp
        );
    }


    /// @inheritdoc ILensHub
    function setState(DataTypes.ProtocolState newState) external override{
        if(msg.sender == _emergencyAdmin){
            if(newState == DataTypes.ProtocolState.Unpaused){
                revert Errors.EmergencyAdminCannotUnpause();
            }
            _validateNotPaused();
        }else if(msg.sender != _governance){
                revert Errors.NotGovernanceOrEmergencyAdmin()
            }

        _setState(newState);
    }


    ///@inheritdoc ILensHub
    function whitelistProfileCreator(address profileCreator, bool whitelist)
        external
        override
        onlyGov
    {
        _profileCreatorWhitelisted[profileCreator] = whitelist;
        emit Events.ProfileCreatorWhitelisted(
            profileCreator,
            whitelist,
            block.timestamp
        );
    }


     /// @inheritdoc ILensHub
    function whitelistFollowModule(address followModule, bool whitelist)
        external
        override
        onlyGov
    {
        _followModuleWhitelisted[followModule] = whitelist;
        emit Events.FollowModuleWhitelisted(
            followModule,
            whitelist,
            block.timestamp
        );
    }

    /// @inheritdoc ILensHub
    function whitelistReferenceModule(address referenceModule, bool whitelist)
        external
        override
        onlyGov
    {
        _referenceModuleWhitelisted[referenceModule] = whitelist;
        emit Events.ReferenceModuleWhitelisted(
            referenceModule,
            whitelist,
            block.timestamp
        );
    }

     /// @inheritdoc ILensHub
    function whitelistCollectModule(address collectModule, bool whitelist)
        external
        override
        onlyGov
    {
        _collectModuleWhitelisted[collectModule] = whitelist;
        emit Events.CollectModuleWhitelisted(
            collectModule,
            whitelist,
            block.timestamp
        );
    }

    ///************************************
    ///***** PROFILE OWNER FUNCTIONS ******
    ///************************************ 

     function createProfile(DataTypes.CreateProfileData calldata vars)
        external
        override
        whenNotPaused
        returns (uint256)
    {
        if (!_profileCreatorWhitelisted[msg.sender])
            revert Errors.ProfileCreatorNotWhitelisted();
        unchecked {
            uint256 profileId = ++_profileCounter;
            _mint(vars.to, profileId);
            PublishingLogic.createProfile(
                vars,
                profileId,
                _profileIdByHandleHash,
                _profileById,
                _followModuleWhitelisted
            );
            return profileId;
        }
    }

     /// @inheritdoc ILensHub
    function setDefaultProfile(uint256 profileId)
        external
        override
        whenNotPaused
    {
        _setDefaultProfile(msg.sender, profileId);
    }

    /// @inheritdoc ILensHub
    function setDefaultProfileWithSig(
        DataTypes.SetDefaultProfileWithSigData calldata vars
    ) external override whenNotPaused {
        unchecked {
            _validateRecoveredAddress(
                _calculateDigest(
                    keccak256(
                        abi.encode(
                            SET_DEFAULT_PROFILE_WITH_SIG_TYPEHASH,
                            vars.wallet,
                            vars.profileId,
                            sigNonces[vars.wallet]++,
                            vars.sig.deadline
                        )
                    )
                ),
                vars.wallet,
                vars.sig
            );
            _setDefaultProfile(vars.wallet, vars.profileId);
        }
    }

    /// @inheritdoc ILensHub
    function setFollowModule(
        uint256 profileId,
        address followModule,
        bytes calldata followModuleInitData
    ) external override whenNotPaused {
        _validateCallerIsProfileOwner(profileId);
        PublishingLogic.setFollowModule(
            profileId,
            followModule,
            followModuleInitData,
            _profileById[profileId],
            _followModuleWhitelisted
        );
    }


    /// @inheritdoc ILensHub
    function setFollowModuleWithSig(
        DataTypes.SetFollowModuleWithSigData calldata vars
    ) external override whenNotPaused {
        address owner = ownerOf(vars.profileId);
        unchecked {
            _validateRecoveredAddress(
                _calculateDigest(
                    keccak256(
                        abi.encode(
                            SET_FOLLOW_MODULE_WITH_SIG_TYPEHASH,
                            vars.profileId,
                            vars.followModule,
                            keccak256(vars.followModuleInitData),
                            sigNonces[owner]++,
                            vars.sig.deadline
                        )
                    )
                ),
                owner,
                vars.sig
            );
        }
        PublishingLogic.setFollowModule(
            vars.profileId,
            vars.followModule,
            vars.followModuleInitData,
            _profileById[vars.profileId],
            _followModuleWhitelisted
        );
    }

    /// @inheritdoc ILensHub
    function setDispatcher(uint256 profileId, address dispatcher)
        external
        override
        whenNotPaused
    {
        _validateCallerIsProfileOwner(profileId);
        _setDispatcher(profileId, dispatcher);
    }

     /// @inheritdoc ILensHub
    function setDispatcherWithSig(
        DataTypes.SetDispatcherWithSigData calldata vars
    ) external override whenNotPaused {
        address owner = ownerOf(vars.profileId);
        unchecked {
            _validateRecoveredAddress(
                _calculateDigest(
                    keccak256(
                        abi.encode(
                            SET_DISPATCHER_WITH_SIG_TYPEHASH,
                            vars.profileId,
                            vars.dispatcher,
                            sigNonces[owner]++,
                            vars.sig.deadline
                        )
                    )
                ),
                owner,
                vars.sig
            );
        }
        _setDispatcher(vars.profileId, vars.dispatcher);
    }

     /// @inheritdoc ILensHub
    function setProfileImageURI(uint256 profileId, string calldata imageURI)
        external
        override
        whenNotPaused
    {
        _validateCallerIsProfileOwnerOrDispatcher(profileId);
        _setProfileImageURI(profileId, imageURI);
    }

    /// @inheritdoc ILensHub
    function setProfileImageURIWithSig(
        DataTypes.SetProfileImageURIWithSigData calldata vars
    ) external override whenNotPaused {
        address owner = ownerOf(vars.profileId);
        unchecked {
            _validateRecoveredAddress(
                _calculateDigest(
                    keccak256(
                        abi.encode(
                            SET_PROFILE_IMAGE_URI_WITH_SIG_TYPEHASH,
                            vars.profileId,
                            keccak256(bytes(vars.imageURI)),
                            sigNonces[owner]++,
                            vars.sig.deadline
                        )
                    )
                ),
                owner,
                vars.sig
            );
        }
        _setProfileImageURI(vars.profileId, vars.imageURI);
    }


    /// @inheritdoc ILensHub
    function setFollowNFTURI(uint256 profileId, string calldata followNFTURI) external override whenNotPaused{
        _validateCallerIsProfileOwnerOrDispathcher(profileId);
        _setFollowNFTURI(profileId, followNFTURI);
    }

    /// @inheritdoc ILensHub
    function setFollowNFTURIWithSig(
        DataTypes.SetFollowNFTURIWithSigData calldata vars
    ) external override whenNotPaused {
        address owner = ownerOf(vars.profileId);
        unchecked {
            _validateRecoveredAddress(
                _calculateDigest(
                    keccak256(
                        abi.encode(
                            SET_FOLLOW_NFT_URI_WITH_SIG_TYPEHASH,
                            vars.profileId,
                            keccak256(bytes(vars.followNFTURI)),
                            sigNonces[owner]++,
                            vars.sig.deadline
                        )
                    )
                ),
                owner,
                vars.sig
            );
        }
        _setFollowNFTURI(vars.profileId, vars.followNFTURI);
    }




    
}
