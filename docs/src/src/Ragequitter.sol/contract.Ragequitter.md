# Ragequitter
[Git Source](https://github.com/Moloch-Mystics/ragequit/blob/8d443b27797d45370cd001aa46ede3a2766571c4/src/Ragequitter.sol)

**Inherits:**
ERC6909

Simple ragequit singleton with ERC6909 accounting. Version 1.


## State Variables
### ETH
========================= CONSTANTS ========================= ///

*The conventional ERC7528 ETH address.*


```solidity
address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
```


### _metadata
========================== STORAGE ========================== ///

*Stores mapping of metadata settings to account token IDs.
note: IDs are unique to addresses (`uint256(uint160(account))`).*


```solidity
mapping(uint256 id => Metadata) internal _metadata;
```


### _settings
*Stores mapping of ragequit settings to accounts.*


```solidity
mapping(address account => Settings) internal _settings;
```


## Functions
### name

================= ERC6909 METADATA & SUPPLY ================= ///

*Returns the name for token `id` using this contract.*


```solidity
function name(uint256 id) public view virtual override(ERC6909) returns (string memory);
```

### symbol

*Returns the symbol for token `id` using this contract.*


```solidity
function symbol(uint256 id) public view virtual override(ERC6909) returns (string memory);
```

### tokenURI

*Returns the URI for token `id` using this contract.*


```solidity
function tokenURI(uint256 id) public view virtual override(ERC6909) returns (string memory);
```

### totalSupply

*Returns the total supply for token `id` using this contract.*


```solidity
function totalSupply(uint256 id) public view virtual returns (uint256);
```

### ragequit

========================== RAGEQUIT ========================== ///

*Ragequits `shares` of `account` loot for their current fair share of pooled `assets`.*


```solidity
function ragequit(address account, uint96 shares, address[] calldata assets) public virtual;
```

### _mulDiv

*Returns `floor(x * y / d)`.
Reverts if `x * y` overflows, or `d` is zero.*


```solidity
function _mulDiv(uint256 x, uint256 y, uint256 d) internal pure virtual returns (uint256 z);
```

### mint

============================ LOOT ============================ ///

*Mints loot shares for an owner of the caller account.*


```solidity
function mint(address owner, uint96 shares) public virtual;
```

### burn

*Burns loot shares from an owner of the caller account.*


```solidity
function burn(address owner, uint96 shares) public virtual;
```

### contribute

========================== TRIBUTE ========================== ///

*Mints loot shares in exchange for tribute `amount` to an `account`.
If no `tribute` is set, then function will revert on `safeTransferFrom`.*


```solidity
function contribute(address account, uint96 amount) public payable virtual;
```

### install

======================== INSTALLATION ======================== ///

*Initializes ragequit settings for the caller account.*


```solidity
function install(Ownership[] calldata owners, Settings calldata setting, Metadata calldata meta)
    public
    virtual;
```

### getMetadata

==================== SETTINGS & METADATA ==================== ///

*Returns the account metadata.*


```solidity
function getMetadata(address account)
    public
    view
    virtual
    returns (string memory, string memory, string memory, IAuth);
```

### getSettings

*Returns the account tribute and ragequit time validity settings.*


```solidity
function getSettings(address account) public view virtual returns (address, uint48, uint48);
```

### setAuth

*Sets new authority contract for the caller account.*


```solidity
function setAuth(IAuth authority) public virtual;
```

### setURI

*Sets account and loot token URI `metadata`.*


```solidity
function setURI(string calldata metadata) public virtual;
```

### setTimeValidity

*Sets account ragequit time validity (or 'time window').*


```solidity
function setTimeValidity(uint48 validAfter, uint48 validUntil) public virtual;
```

### setTribute

*Sets account contribution asset (tribute).*


```solidity
function setTribute(address tribute) public virtual;
```

### _balanceOf

=================== EXTERNAL ASSET HELPERS =================== ///

*Returns the `amount` of ERC20 `token` owned by `account`.
Returns zero if the `token` does not exist.*


```solidity
function _balanceOf(address token, address account)
    internal
    view
    virtual
    returns (uint256 amount);
```

### _safeTransferETH

*Sends `amount` (in wei) ETH to `to`.*


```solidity
function _safeTransferETH(address to, uint256 amount) internal virtual;
```

### _safeTransferFrom

*Sends `amount` of ERC20 `token` from `from` to `to`.*


```solidity
function _safeTransferFrom(address token, address from, address to, uint256 amount)
    internal
    virtual;
```

### _beforeTokenTransfer

========================= OVERRIDES ========================= ///

*Hook that is called before any transfer of tokens.
This includes minting and burning. Also requests authority for token transfers.*


```solidity
function _beforeTokenTransfer(address from, address to, uint256 id, uint256 amount)
    internal
    virtual
    override(ERC6909);
```

## Events
### URI
=========================== EVENTS =========================== ///

*Logs new account loot metadata.*


```solidity
event URI(string metadata, uint256 indexed id);
```

### AuthSet
*Logs new account authority contract.*


```solidity
event AuthSet(address indexed account, IAuth authority);
```

### TributeSet
*Logs new account contribution asset setting.*


```solidity
event TributeSet(address indexed account, address tribute);
```

### TimeValiditySet
*Logs new account ragequit time validity setting.*


```solidity
event TimeValiditySet(address indexed account, uint48 validAfter, uint48 validUntil);
```

## Errors
### InvalidTime
======================= CUSTOM ERRORS ======================= ///

*Invalid time window for ragequit.*


```solidity
error InvalidTime();
```

### InvalidAssetOrder
*Out-of-order redemption assets.*


```solidity
error InvalidAssetOrder();
```

### MulDivFailed
*Overflow or division by zero.*


```solidity
error MulDivFailed();
```

### TransferFromFailed
*ERC20 `transferFrom` failed.*


```solidity
error TransferFromFailed();
```

### ETHTransferFailed
*ETH transfer failed.*


```solidity
error ETHTransferFailed();
```

## Structs
### Metadata
========================== STRUCTS ========================== ///

*The account loot shares metadata struct.*


```solidity
struct Metadata {
    string name;
    string symbol;
    string tokenURI;
    IAuth authority;
    uint96 totalSupply;
}
```

### Ownership
*The account loot shares ownership struct.*


```solidity
struct Ownership {
    address owner;
    uint96 shares;
}
```

### Settings
*The account loot shares settings struct.*


```solidity
struct Settings {
    address tribute;
    uint48 validAfter;
    uint48 validUntil;
}
```

