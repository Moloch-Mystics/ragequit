# Ragequitter
[Git Source](https://github.com/Moloch-Mystics/ragequit/blob/845182b2b2d7e42a6f2d55820158fafa420ea59e/src/Ragequitter.sol)

Simple ragequitter singleton. Uses pseudo-ERC-1155 accounting.


## State Variables
### settings
========================== STORAGE ========================== ///

*Public settings for account ragequit.*


```solidity
mapping(address => Settings) public settings;
```


### totalSupply
*Public total supply for account loot.*


```solidity
mapping(uint256 => uint256) public totalSupply;
```


### balanceOf
*Public loot balances for account token holders.*


```solidity
mapping(uint256 => mapping(address => uint256)) public balanceOf;
```


## Functions
### ragequit

========================== RAGEQUIT ========================== ///

*Ragequit redeem `amount` of `account` loot for `assets`.*


```solidity
function ragequit(address account, uint256 amount, address[] calldata assets) public virtual;
```

### _mulDiv

*Returns `floor(x * y / d)`.
Reverts if `x * y` overflows, or `d` is zero.*


```solidity
function _mulDiv(uint256 x, uint256 y, uint256 d) internal pure virtual returns (uint256 z);
```

### mint

============================ LOOT ============================ ///

*Mint `amount` of loot token shares for `to`.*


```solidity
function mint(address to, uint256 amount) public virtual;
```

### burn

*Burn `amount` of loot token shares for `from`.*


```solidity
function burn(address from, uint256 amount) public virtual;
```

### _balanceOf

=========================== TOKENS =========================== ///

*Returns the `amount` of ERC20 `token` owned by `account`.
Returns zero if the `token` does not exist.*


```solidity
function _balanceOf(address token, address account)
    internal
    view
    virtual
    returns (uint256 amount);
```

### _safeTransferFrom

*Sends `amount` of ERC20 `token` from `from` to `to`.*


```solidity
function _safeTransferFrom(address token, address from, address to, uint256 amount)
    internal
    virtual;
```

### install

======================== INSTALLATION ======================== ///

*Initializes ragequit settings for the caller account.*


```solidity
function install(uint48 validAfter, uint48 validUntil) public virtual;
```

## Events
### TransferSingle
=========================== EVENTS =========================== ///

*Emitted when `amount` of token `id` is transferred
from `from` to `to` by `operator`.*


```solidity
event TransferSingle(
    address indexed operator, address indexed from, address indexed to, uint256 id, uint256 amount
);
```

## Errors
### TransferFromFailed
======================= CUSTOM ERRORS ======================= ///

*The ERC20 `transferFrom` has failed.*


```solidity
error TransferFromFailed();
```

### InvalidTime
*Invalid time window for ragequit.*


```solidity
error InvalidTime();
```

### InvalidAssetOrder

```solidity
error InvalidAssetOrder();
```

### MulDivFailed
*Overflow or division by zero.*


```solidity
error MulDivFailed();
```

## Structs
### Settings
========================== STRUCTS ========================== ///

*The account ragequit settings.*


```solidity
struct Settings {
    uint48 validAfter;
    uint48 validUntil;
}
```

