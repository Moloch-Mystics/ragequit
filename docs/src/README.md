# [ragequit](https://github.com/Moloch-Mystics/ragequit)  [![License: AGPL-3.0-only](https://img.shields.io/badge/License-AGPL-black.svg)](https://opensource.org/license/agpl-v3/) [![solidity](https://img.shields.io/badge/solidity-%5E0.8.25-black)](https://docs.soliditylang.org/en/v0.8.25/) [![Foundry](https://img.shields.io/badge/Built%20with-Foundry-000000.svg)](https://getfoundry.sh/) ![tests](https://github.com/Moloch-Mystics/ragequit/actions/workflows/ci.yml/badge.svg)

*Ragequit everywhere.* Fair-share *ragequit* redemptions router for any token burn. Developed and deployed as the [Ragequitter](./src/Ragequitter.sol) solidity singleton.

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
