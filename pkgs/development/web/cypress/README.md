This nix package generates the [Cypress](https://www.cypress.io/) binary compiled and installed by the native npm package found at [npm js repository](https://www.npmjs.com/package/cypress) for other linux distros.

## Installation and usage

The regular installation process ([as instructed here](https://docs.cypress.io/guides/getting-started/installing-cypress.html)) will not work given the nature of Nix packaging system.

Install the nix package `nix-env -iA nixpkgs.cypress` or adding to your nixos config if running NixOS.

Then install cypress npm package and run the binary (Electron app) passing the environment variables:

```
$ cd path/to/your/app
$ CYPRESS_INSTALL_BINARY=0 npm i cypress
$ CYPRESS_RUN_BINARY=~/.nix-profile/bin/Cypress $(npm bin)/cypress open
```
