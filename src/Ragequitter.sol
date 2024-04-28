// ᗪᗩGOᑎ 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {ERC6909} from "@solady/src/tokens/ERC6909.sol";

/// @notice Simple ragequitter singleton. Uses ERC6909 minimal multitoken.
contract Ragequitter is ERC6909 {
    /// ======================= CUSTOM ERRORS ======================= ///

    /// @dev The ERC20 `transferFrom` has failed.
    error TransferFromFailed();

    /// @dev Invalid time window for ragequit.
    error InvalidTime();

    // @dev Out-of-order redemption assets.
    error InvalidAssetOrder();

    /// @dev Overflow or division by zero.
    error MulDivFailed();

    /// =========================== EVENTS =========================== ///

    /// @dev Logs new loot metadata setting.
    event URI(string metadata, uint256 indexed id);

    /// @dev Logs new authority contract for an account.
    event AuthSet(address indexed account, IAuth auth);

    /// @dev Logs new account ragequit time validity setting.
    event TimeValiditySet(address indexed account, uint48 validAfter, uint48 validUntil);

    /// ========================== STRUCTS ========================== ///

    /// @dev The account loot metadata struct.
    struct Metadata {
        string name;
        string symbol;
        string tokenURI;
        IAuth authority;
        uint96 totalSupply;
    }

    /// @dev The account loot shares struct.
    struct Ownership {
        address owner;
        uint96 shares;
    }

    /// @dev The account ragequit settings struct.
    struct Settings {
        uint48 validAfter;
        uint48 validUntil;
    }

    /// ========================== STORAGE ========================== ///

    /// @dev Stores mapping of metadata settings to account token IDs.
    /// note: IDs are unique to addresses (`uint256(uint160(account))`).
    mapping(uint256 id => Metadata) internal _metadata;

    /// @dev Stores mapping of ragequit settings to accounts.
    mapping(address account => Settings) internal _settings;

    /// ================= ERC6909 METADATA & SUPPLY ================= ///

    /// @dev Returns the name for token `id` using this contract.
    function name(uint256 id) public view virtual override(ERC6909) returns (string memory) {
        return _metadata[id].name;
    }

    /// @dev Returns the symbol for token `id` using this contract.
    function symbol(uint256 id) public view virtual override(ERC6909) returns (string memory) {
        return _metadata[id].symbol;
    }

    /// @dev Returns the URI for token `id` using this contract.
    function tokenURI(uint256 id) public view virtual override(ERC6909) returns (string memory) {
        return _metadata[id].tokenURI;
    }

    /// @dev Returns the total supply for token `id` using this contract.
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return _metadata[id].totalSupply;
    }

    /// ========================== RAGEQUIT ========================== ///

    /// @dev Ragequits `shares` of `account` loot for their current fair share of pooled `assets`.
    function ragequit(address account, uint96 shares, address[] calldata assets) public virtual {
        Settings storage setting = _settings[account];

        if (block.timestamp < setting.validAfter) revert InvalidTime();
        if (block.timestamp > setting.validUntil) revert InvalidTime();

        uint256 id = uint256(uint160(account));
        uint256 supply = _metadata[id].totalSupply;
        unchecked {
            _metadata[id].totalSupply -= shares;
        }
        _burn(msg.sender, id, shares);

        address asset;
        address prev;

        for (uint256 i; i != assets.length; ++i) {
            asset = assets[i];
            if (asset <= prev) revert InvalidAssetOrder();
            prev = asset;
            uint256 share = _mulDiv(shares, _balanceOf(asset, account), supply);
            if (share != 0) _safeTransferFrom(asset, account, msg.sender, share);
        }
    }

    /// @dev Returns `floor(x * y / d)`.
    /// Reverts if `x * y` overflows, or `d` is zero.
    function _mulDiv(uint256 x, uint256 y, uint256 d) internal pure virtual returns (uint256 z) {
        assembly ("memory-safe") {
            // Equivalent to require(d != 0 && (y == 0 || x <= type(uint256).max / y))
            if iszero(mul(d, iszero(mul(y, gt(x, div(not(0), y)))))) {
                mstore(0x00, 0xad251c27) // `MulDivFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(mul(x, y), d)
        }
    }

    /// ======================== INSTALLATION ======================== ///

    /// @dev Initializes ragequit settings for the caller account.
    function install(Ownership[] calldata owners, Settings calldata setting, Metadata calldata meta)
        public
        virtual
    {
        uint256 id = uint256(uint160(msg.sender));
        _settings[msg.sender] = Settings(setting.validAfter, setting.validUntil);
        if (owners.length != 0) {
            uint96 supply;
            for (uint256 i; i != owners.length;) {
                supply += owners[i].shares;
                _mint(owners[i].owner, id, owners[i].shares);
                unchecked {
                    ++i;
                }
            }
            _metadata[id].totalSupply += supply;
        }
        if (bytes(meta.name).length != 0) {
            _metadata[id].name = meta.name;
            _metadata[id].symbol = meta.symbol;
        }
        if (bytes(meta.tokenURI).length != 0) _metadata[id].tokenURI = meta.tokenURI;
        if (meta.authority != IAuth(address(0))) _metadata[id].authority = meta.authority;
    }

    /// @dev Sets new authority contract for the caller account.
    function setAuth(IAuth auth) public virtual {
        emit AuthSet(msg.sender, (_metadata[uint256(uint160(msg.sender))].authority = auth));
    }

    /// @dev Sets account and loot token URI `metadata`.
    function setURI(string calldata metadata) public virtual {
        uint256 id = uint256(uint160(msg.sender));
        emit URI(_metadata[id].tokenURI = metadata, id);
    }

    /// @dev Sets account ragequit time validity (or 'timespan').
    function setTimeValidity(uint48 validAfter, uint48 validUntil) public virtual {
        _settings[msg.sender] = Settings(validAfter, validUntil);
        emit TimeValiditySet(msg.sender, validAfter, validUntil);
    }

    /// ============================ LOOT ============================ ///

    /// @dev Returns the account metadata.
    function getMetadata(address account)
        public
        view
        virtual
        returns (string memory, string memory, string memory, IAuth)
    {
        Metadata storage meta = _metadata[uint256(uint160(account))];
        return (meta.name, meta.symbol, meta.tokenURI, meta.authority);
    }

    /// @dev Returns the account ragequit time validity settings.
    function getSettings(address account) public view virtual returns (uint48, uint48) {
        Settings storage setting = _settings[account];
        return (setting.validAfter, setting.validUntil);
    }

    /// @dev Mints loot shares for an owner of the caller account.
    function mint(address owner, uint96 shares) public payable virtual {
        uint256 id = uint256(uint160(msg.sender));
        _metadata[id].totalSupply += shares;
        _mint(owner, id, shares);
    }

    /// @dev Burns loot shares from an owner of the caller account.
    function burn(address owner, uint96 shares) public payable virtual {
        uint256 id = uint256(uint160(msg.sender));
        unchecked {
            _metadata[id].totalSupply -= shares;
        }
        _burn(owner, id, shares);
    }

    /// =================== EXTERNAL TOKEN HELPERS =================== ///

    /// @dev Returns the `amount` of ERC20 `token` owned by `account`.
    /// Returns zero if the `token` does not exist.
    function _balanceOf(address token, address account)
        internal
        view
        virtual
        returns (uint256 amount)
    {
        assembly ("memory-safe") {
            mstore(0x14, account) // Store the `account` argument.
            mstore(0x00, 0x70a08231000000000000000000000000) // `balanceOf(address)`.
            amount :=
                mul( // The arguments of `mul` are evaluated from right to left.
                    mload(0x20),
                    and( // The arguments of `and` are evaluated from right to left.
                        gt(returndatasize(), 0x1f), // At least 32 bytes returned.
                        staticcall(gas(), token, 0x10, 0x24, 0x20, 0x20)
                    )
                )
        }
    }

    /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
    function _safeTransferFrom(address token, address from, address to, uint256 amount)
        internal
        virtual
    {
        assembly ("memory-safe") {
            let m := mload(0x40) // Cache the free memory pointer.
            mstore(0x60, amount) // Store the `amount` argument.
            mstore(0x40, to) // Store the `to` argument.
            mstore(0x2c, shl(96, from)) // Store the `from` argument.
            mstore(0x0c, 0x23b872dd000000000000000000000000) // `transferFrom(address,address,uint256)`.
            // Perform the transfer, reverting upon failure.
            if iszero(
                and( // The arguments of `and` are evaluated from right to left.
                    or(eq(mload(0x00), 1), iszero(returndatasize())), // Returned 1 or nothing.
                    call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
                )
            ) {
                mstore(0x00, 0x7939f424) // `TransferFromFailed()`.
                revert(0x1c, 0x04)
            }
            mstore(0x60, 0) // Restore the zero slot to zero.
            mstore(0x40, m) // Restore the free memory pointer.
        }
    }

    /// ========================= OVERRIDES ========================= ///

    /// @dev Hook that is called before any transfer of tokens.
    /// This includes minting and burning. Also requests authority for token transfers.
    function _beforeTokenTransfer(address from, address to, uint256 id, uint256 amount)
        internal
        virtual
        override(ERC6909)
    {
        IAuth auth = _metadata[id].authority;
        if (auth != IAuth(address(0))) auth.validateTransfer(from, to, id, amount);
    }
}

/// @notice Simple authority interface for contracts.
interface IAuth {
    function validateTransfer(address, address, uint256, uint256)
        external
        payable
        returns (uint256);
}
