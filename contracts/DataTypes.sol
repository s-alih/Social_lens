//SPDX-Licence-Identifier: MIT

pragma solidity 0.8.10;

/**
 * @title DataTypes
 * @author Lens Protocol
 *
 * @notice S standard library of data types thoughout the Lens Protocol.
 *
 */

library DataTypes {
    /**
     * @notice An enum containing the different states the protocol can be in, limiting certain actions.
     *
     * @param UnPaused The fully unpaused state.
     * @param PublishingPaused The state where only publication creation functions are paused.
     * @param Paused The pully paused state
     */

    enum ProtocolState {
        UnPaused,
        PublishingPaused,
        Paused
    }

    /**
     * @notice An enum specifically used in a helper funcitno to easily retrive the publication type for integrations.
     *
     * @param Post A standard post haveing a URI, a collecct module but no pointer to another publication.
     * @param Comment A comment, having a URI,  a collect module and a pointer to another publications
     * @param Mirror a mirror, having a pointer to another publication, but no URI or collect module.
     * @param Nonexistent An indicator showing the quiried  publication does not exist.
     */

    enum PubType {
        Post,
        Comment,
        Mirror,
        Nonexistent
    }

    /**
     * @notice A struct containing the necessary information to reconstruct an EIP-712 typed data signature
     *
     * @param v The signature's recovery parameter
     * @param r The signature's r parameter.
     * @param s The signature's s parameter
     * @param deadline The signature's deadline
     */

    struct EIP712Signature {
        uint256 v;
        bytes32 r;
        bytes32 s;
        uint256 deadline;
    }

    /**
     * @notice A struct containing profile data.
     *
     * @param pubCount The number of publications made to this profile
     * @param folloModule The address of the current follow module in use by this profile. can be empty.
     * @param followNFT The address of the followNFT associated with this profile
     * @param handle The profile's associated handle.
     * @param imageURI The URI to be used for the profile's image.
     * @param followNFTURI The URI to be used for the follow NFT
     */

    struct ProfileStruct {
        uint256 pubCount;
        address followModule;
        address followNFT;
        string handle;
        string imageURI;
        string followNFTURI;
    }

    /**
     * @notice A struct containing data associated with each new publication.
     *
     * @param profileIdPointed The profile token ID this publication points to, for mirrors and comments.
     * @param pubIdPointed The publication ID this publication points to, for mirrors and comments.
     * @param contentURI The URI associated with this publication.
     * @param referenceModule The address of the current refernce module with this publication, this exists for all publication.
     * @param collectModule The address of the collect module associated with this publication, this exists for all publication.
     * @param collectNFT the address of the collecNFT associated with this publication,if any.
     *
     */

    struct PublicationStruct {
        uint256 pofileIdPointed;
        uint256 pubIdPointed;
        string contentURI;
        address referenceModule;
        address collectModule;
        address collectNFT;
    }

    /**
     * @notice A struct containing the parameters for the  `createProfile()` function.
     *
     * @param to The address reciveing the profile.
     * @param handle The handle to set for the profile, must be unique and non-empty.
     * @param imageURI The URI to set for the profile image.
     * @param followModule The follow module to use, can the zero address.
     * @param followModuleInitData The follow module initilaization data, if any.
     * @param followNFTURI The URI to use for the follow NFT.
     */

    struct CreateProfileData {
        address to;
        string handle;
        string imageURI;
        address followModule;
        bytes followModuleInitData;
        string followNFTURI;
    }

    /**
     * @notice A struct containing the parameters required for the `setDefaultProfileWithSig()` function, Parameters are
     * the same as the reqular  `setDefaultProfile()` function with an added EIP721Signature.
     *
     * @param wallet The address of the wallet setting the default profile.
     * @param profileId The token ID of the profle which will be set as default,or zero.
     * @param sig The EIP712Signature struct  containing the profile owner's signature.
     */

    struct setDefaultProfileWithSigData {
        address wallet;
        uint256 profileId;
        EIP721Signature sig;
    }

    /**
     * @notice A struct containing the parameters required fot he  `setFollowModuleWithSig()` function . parameters are
     * the same as the regular `setFollowModule()`  function, with an added EIP721Signature.
     *
     * @param profileId The token ID of the profile to change the followModule for.
     * @param followModule The followModule to set for the given profile. must be whitlisted.
     * @param followModuleInitData The data to be passed to the followModule for initialization.
     * @param sig The EIP721Signature struct containing the profile owner's signature.
     */

    struct SetFollowModuleWithSigData {
        uint256 profileId;
        address followModule;
        bytes followModuleInitData;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the prameters required fo the `setDispatcherWithSig()` funciton. parameters are same
     * as the regular  `setDispatcher()` function, with an added EIP721Signature.
     *
     * @param profileId The token ID of the profile to set the dispatcher for.
     * @param dispatcher The dipatcher address to set for the profile
     * @param sig The EIP721Signature struct containing the profile owner's singature.
     */

    struct SetDispatcherWithSigData {
        uint256 profileId;
        address dipatcher;
        EIP721Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `setProfileImageURIWithSig()`function. Parameters are the same
     * as the regular `setProfileImageURI()` function, with an added EIP712Signature.
     *
     * @param profileId The Token ID of the profile to set the URI for,
     * @param imageURI The URI to set for the given profile imate.
     * @param sig The EIP721Singature struct containing the profile owner's signature
     */

    struct SetProfileImageURIWithsigData {
        uint256 profileId;
        string imageURI;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `setFollowNFTURIWithSig()` funtion, parameters are same as
     * regular   `setFollowNFTURI` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile for which to set the followNFI URI.
     * @param followNFIURI The follow NFT URI to set.
     * @param sig The EIP712Signature struct containing the followNFT's associated profile owner's signature
     *
     */

    struct SetFollowNFTWitSigData {
        uint256 profileId;
        string followNFTURI;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `post()`  function
     *
     * @param profileId The token ID of the profile to publish to.
     * @param contentURI The URI to set fo the new publication
     * @param collectModule The collect module to set for the publication
     * @param collectModuleInitData The data to pass to the collect module's initilization.
     * @param referenceModule The reference module to set for the the given publication, must be whitelisted.
     * @param referenceModuleInitData The data to be passed to the reference module for initialization.
     */

    struct PostData {
        uint256 profileId;
        string contentURI;
        address collectModule;
        bytes collectModuleInitData;
        address referenceModule;
        bytes referenceModuleInitData;
    }

    /**
     * @notice A struct containing the parameters required for the `postWithSig()`  function. Parameters are same as
     * the regular `post()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param contentURI The URI to set fo the new publication
     * @param collectModule The collect module to set for the publication
     * @param collectModuleInitData The data to pass to the collect module's initilization.
     * @param referenceModule The reference module to set for the the given publication, must be whitelisted.
     * @param referenceModuleInitData The data to be passed to the reference module for initialization.
     * @param sig The EIP712Signature struct containing th profile owner's signature.
     */

    struct PostData {
        uint256 profileId;
        string contentURI;
        address collectModule;
        bytes collectModuleInitData;
        address referenceModule;
        bytes referenceModuleInitData;
    }

    /**
     * @notice A struct containing the parameters required fo the  `comment()` function .
     *
     * @param profileId The toke ID of the profile to publish to.
     * @param contentURI the URI to set this new publication.
     * @param profileIdPointed The token IDto point the comment to.
     * @param pubIdPointed The Publication ID to point the comment to.
     * @param referenceModuleData The data passed to reference module.
     * @param collectModule The collect module to set for the this new publication.
     * @param collectModuleInitData The data to pass to the collect module's initialization.
     * @param referenceModule The reference module to set fo the given publication, must be whitelisted.
     * @param referenceModuleInitData The data to be passed to the reference module for the initialization.
     */

    struct CommentData {
        uint256 profileId;
        string contentURI;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        bytes referenceModuleData;
        address collectModule;
        bytes collectModuleInitData;
        address referenceModule;
        bytes referenceModuleInitData;
    }

    /**
     * @notice A struct containing the parameters required for the `commentWithSig()` function. Parameters are the same as
     * the regular `comment()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param contentURI The URI to set for this new publication.
     * @param profileIdPointed The profile token ID to point the comment to.
     * @param pubIdPointed The publication ID to point the comment to.
     * @param referenceModuleData The data passed to the reference module.
     * @param collectModule The collectModule to set for this new publication.
     * @param collectModuleInitData The data to pass to the collectModule's initialization.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleInitData The data to be passed to the reference module for initialization.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct CommentWithSigData {
        uint256 profileId;
        string contentURI;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        bytes referenceModuleData;
        address collectModule;
        bytes collectModuleInitData;
        address referenceModule;
        bytes referenceModuleInitData;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `mirror()` function.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param profileIdPointed The profile token ID to point the mirror to.
     * @param pubIdPointed The publication ID to point the mirror to.
     * @param referenceModuleData The data passed to the referece module.
     * @param referenceModule The reference module to set for the given publication.
     * @param referenceModuleInitData The data to be passed to the reference module for the initialization
     */

    struct MirrorData {
        uint256 profileid;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        bytes referenceModuleData;
        address referenceModule;
        bytes referecneModuleInitData;
    }

    /**
     * @notice A struct containing the parameters required for the `mirrorWithSig()` function. Parameters are the same as
     * the regular `mirror()` function, with an added EIP712Signature.
     *
     * @param profileId The token ID of the profile to publish to.
     * @param profileIdPointed The profile token ID to point the mirror to.
     * @param pubIdPointed The publication ID to point the mirror to.
     * @param referenceModuleData The data passed to the reference module.
     * @param referenceModule The reference module to set for the given publication, must be whitelisted.
     * @param referenceModuleInitData The data to be passed to the reference module for initialization.
     * @param sig The EIP712Signature struct containing the profile owner's signature.
     */
    struct MirrorWithSigData {
        uint256 profileId;
        uint256 profileIdPointed;
        uint256 pubIdPointed;
        bytes referenceModuleData;
        address referenceModule;
        bytes referenceModuleInitData;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required fo the `followWithSig()` function. parameters are the same as
     * regular `follow()` function, with the follower's (signer) address and an EIP712Signature added.
     *
     *
     * @param follower The follower which is the nessage signer
     * @param profileIds the array of token ID's of the profile to follow.
     * @param datas The array of the arbitary data to pass to the followModule if needed.
     * @param sig The EIP712Signature struct containing the follower's singature.
     */

    struct FollowWithSigData {
        address follower;
        uint256[] profileId;
        bytes[] datas;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required fo the `collecWithSig()` function. Parameters are the same as
     * the reqular `collec()` function, with the collector's (signer) address and EIP712Signature added.
     *
     *
     * @param collector The collector which is the message signer
     * @param profileId The token ID of the profile theat published the publication
     * @param pubId The publication to collect's publication ID.
     * @param data The aritarary dat to pass to the collectModule if needed.
     * @param sig The EIP712Signature struct containing the collector's signature.
     */

    struct CollectWithSigData {
        address collector;
        uint256 profileId;
        uint256 pubId;
        bytes data;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `setProfileMetadataWithSig()`
     *
     * @param profileId The profile ID for which to set the metadat.
     * @param metadata The metadata string to set for the profile and user
     * @param sig The EIP712Signature struct containing the user's signature.
     */

    struct SetProfileMetadataWithSigData {
        uint256 profileId;
        string metadata;
        EIP712Signature sig;
    }

    /**
     * @notice A struct containing the parameters required for the `toggleFollowWithSig()` function.
     *
     * @param follower The follower which is message signer
     * @param profileIds The token ID array of the profiles.
     * @param  enables The array of booleans to enable/disable folows.
     * @param sig the EIP712Signature struct containing the follower's signature.
     */

    struct ToggleFollwWithSigData {
        address follower;
        uint256[] profieIds;
        bool[] enables;
        EIP712Signature sig;
    }
}
