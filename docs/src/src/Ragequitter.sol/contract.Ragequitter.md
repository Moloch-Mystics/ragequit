# Ragequitter
[Git Source](https://github.com/Moloch-Mystics/ragequit/blob/86d6dd99cf3f73cadf56ed6fdfbc85c29c7189ff/src/Ragequitter.sol)

**Inherits:**
ERC6909

Simple ragequitter singleton. Uses ERC6909 minimal multitoken.


## State Variables
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

### install

======================== INSTALLATION ======================== ///

*Initializes ragequit settings for the caller account.*


```solidity
function install(Ownership[] calldata owners, Settings calldata setting, Metadata calldata meta)
    public
    virtual;
```

### setAuth

*Sets new authority contract for the caller account.*


```solidity
function setAuth(IAuth auth) public virtual;
```

### setURI

*Sets account and loot token URI `metadata`.*


```solidity
function setURI(string calldata metadata) public virtual;
```

### setTimeValidity

*Sets account ragequit time validity (or 'timespan').*


```solidity
function setTimeValidity(uint48 validAfter, uint48 validUntil) public virtual;
```

### getMetadata

============================ LOOT ============================ ///

*Returns the account metadata.*


```solidity
function getMetadata(address account)
    public
    view
    virtual
    returns (string memory, string memory, string memory, IAuth);
```

### getSettings

*Returns the account ragequit time validity settings.*


```solidity
function getSettings(address account) public view virtual returns (uint48, uint48);
```

### mint

*Mints loot shares for an owner of the caller account.*


```solidity
function mint(address owner, uint96 shares) public payable virtual;
```

### burn

*Burns loot shares from an owner of the caller account.*


```solidity
function burn(address owner, uint96 shares) public payable virtual;
```

### _balanceOf

=================== EXTERNAL TOKEN HELPERS =================== ///

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

*Logs new loot metadata setting.*


```solidity
event URI(string metadata, uint256 indexed id);
```

### AuthSet
*Logs new authority contract for an account.*


```solidity
event AuthSet(address indexed account, IAuth auth);
```

### TimeValiditySet
*Logs new account ragequit time validity setting.*


```solidity
event TimeValiditySet(address indexed account, uint48 validAfter, uint48 validUntil);
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
### Metadata
========================== STRUCTS ========================== ///

*The account loot metadata struct.*


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
*The account loot shares struct.*


```solidity
struct Ownership {
    address owner;
    uint96 shares;
}
```

### Settings
*The account ragequit settings struct.*


```solidity
struct Settings {
    uint48 validAfter;
    uint48 validUntil;
}
```

