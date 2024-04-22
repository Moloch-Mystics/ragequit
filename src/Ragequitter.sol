// ᗪᗩGOᑎ 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭 𒀭
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

/// @notice Simple ragequitter singleton. Uses pseudo-ERC-1155 accounting.
contract Ragequitter {
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

    /// @dev Emitted when `amount` of token `id` is transferred
    /// from `from` to `to` by `operator`.
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 amount
    );

    /// ========================== STRUCTS ========================== ///

    /// @dev The account ragequit settings.
    struct Settings {
        uint48 validAfter;
        uint48 validUntil;
    }

    /// ========================== STORAGE ========================== ///

    /// @dev Public settings for account ragequit.
    mapping(address => Settings) public settings;

    /// @dev Public total supply for account loot.
    mapping(uint256 => uint256) public totalSupply;

    /// @dev Public loot balances for account token holders.
    mapping(uint256 => mapping(address => uint256)) public balanceOf;

    /// ========================== RAGEQUIT ========================== ///

    /// @dev Ragequit redeem `amount` of `account` loot for `assets`.
    function ragequit(address account, uint256 amount, address[] calldata assets) public virtual {
        Settings storage set = settings[account];

        if (block.timestamp < set.validAfter) revert InvalidTime();
        if (block.timestamp > set.validUntil) revert InvalidTime();

        uint256 id = uint256(uint160(account));
        balanceOf[id][msg.sender] -= amount;
        uint256 supply = totalSupply[id];
        unchecked {
            totalSupply[id] -= amount;
        }

        address asset;
        address prev;

        for (uint256 i; i != assets.length; ++i) {
            asset = assets[i];
            if (asset < prev) revert InvalidAssetOrder();
            prev = asset;
            uint256 share = _mulDiv(amount, _balanceOf(asset, account), supply);
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

    /// ============================ LOOT ============================ ///

    /// @dev Mint `amount` of loot token shares for `to`.
    function mint(address to, uint256 amount) public virtual {
        uint256 id = uint256(uint160(msg.sender));
        unchecked {
            balanceOf[id][to] += amount;
        }
        totalSupply[id] += amount;
        emit TransferSingle(msg.sender, address(0), to, id, amount);
    }

    /// @dev Burn `amount` of loot token shares for `from`.
    function burn(address from, uint256 amount) public virtual {
        uint256 id = uint256(uint160(msg.sender));
        balanceOf[id][from] -= amount;
        unchecked {
            totalSupply[id] -= amount;
        }
        emit TransferSingle(msg.sender, from, address(0), id, amount);
    }

    /// =========================== TOKENS =========================== ///

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

    /// ======================== INSTALLATION ======================== ///

    /// @dev Initializes ragequit settings for the caller account.
    function install(uint48 validAfter, uint48 validUntil) public virtual {
        settings[msg.sender] = Settings(validAfter, validUntil);
    }
}
