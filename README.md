# [ragequit](https://github.com/Moloch-Mystics/ragequit)  [![License: AGPL-3.0-only](https://img.shields.io/badge/License-AGPL-black.svg)](https://opensource.org/license/agpl-v3/) [![solidity](https://img.shields.io/badge/solidity-%5E0.8.25-black)](https://docs.soliditylang.org/en/v0.8.25/) [![Foundry](https://img.shields.io/badge/Built%20with-Foundry-000000.svg)](https://getfoundry.sh/) ![tests](https://github.com/Moloch-Mystics/ragequit/actions/workflows/ci.yml/badge.svg)

*Ragequit* redemption for all accounts. Developed and deployed as the [Ragequitter](./src/Ragequitter.sol) solidity singleton.

V1 Deployment: [0x0000000000008743D388E5279B2A9EF87A3115Ae](https://arbiscan.io/address/0x0000000000008743d388e5279b2a9ef87a3115ae#code)

## How it works

Let's say you have a Gnosis Safe or smart account or DAO treasury. And you want to make it so people can take tokens out of your account without a proposal by burning other tokens ("redemption", and those other tokens, "loot"). The classic use case of this is the ["Moloch DAO ragequit"](https://github.com/MolochVentures/moloch/blob/master/contracts/Moloch.sol#L528), which is a game theory mechanism that serves trustless crowdfunding ("tribute") by guaranteeing contributors that they can always get their share of tribute back if they burn loot. 

Such moloch-style ragequit functionality can be extended to a variety of contract accounts today (and in the near future, even EOAs via EIP-3074) as a module through a singleton contract instance that serves to route token approvals and redemptions based on basic "fair share" (muldiv) math (basically, your '%' of total loot supply should equate to the '%' of assets you can claim).

How? Well, most account contracts are usually capable of executing arbitrary logic and calldata payloads approved by their owners. One such logic is to make an ERC20 token approval that gives another account the right to spend tokens on their behalf (up to a certain capped amount that is always ultimately adjustable by the approving account). Within this standard and delegation practices, accounts can similarly leverage `Ragequitter` by giving it token approvals up to amounts they want to attribute as ragequittable by their loot holders (these approvals effectively fill the potential array of `assets` subject to `ragequit`). Loot shares are then able to minted and burned remotely by such parent accounts to grant the right to claim approved `assets`. A timespan can also be adjusted for ragequit redemption windows (see, `Settings`). When loot holders want to claim such tokens (and within such settings), they call `ragequit` on `Ragequitter` and their fair share of assets are pulled from the parent account and into theirs. The relevant account loot shares are then burned and the total supply of loot is also adjusted to reflect each redemption (where each loot `id` is just the number cast of the `account` as `uint256(uint160(account))`).

The [ERC6909 minimal multitoken standard](https://eips.ethereum.org/EIPS/eip-6909) is used to represent loot shares and handle their accounting and event logs. Loot is optionally transferable and non-transferable with the ability to include arbitrary conditions and logic through the extension of `authority` contracts attributed to each account's general `Metadata` hosted in `Ragequitter`.

## Getting Started

Run: `curl -L https://foundry.paradigm.xyz | bash && source ~/.bashrc && foundryup`

Build the foundry project with `forge build`. Run tests with `forge test`. Measure gas with `forge snapshot`. Format with `forge fmt`.

## GitHub Actions

Contracts will be tested and gas measured on every push and pull request.

You can edit the CI script in [.github/workflows/ci.yml](./.github/workflows/ci.yml).

## Blueprint

```txt
lib
├─ account — https://github.com/NaniDAO/accounts
├─ forge-std — https://github.com/foundry-rs/forge-std
├─ solady — https://github.com/vectorized/solady
src
├─ Ragequitter — Ragequitter Contract
test
└─ Ragequitter.t - Test Ragequitter Contract
```

## Disclaimer

*These smart contracts and testing suite are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of anything provided herein or through related user interfaces. This repository and related code have not been audited and as such there can be no assurance anything will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk.*

## License

See [LICENSE](./LICENSE) for more details.
