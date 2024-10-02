# Steps for Testing New Releases

## Patch Releases or Updating `nixVersions.{latest,git}`

Branch to merge into: **master** or **release-$nixos-version**

Build the affected Nix packages and run their tests on the following platforms: **x86_64-linux**, **aarch64-linux**, **x86_64-darwin**, and **aarch64-darwin**.
If you lack the necessary hardware for these platforms, you may need to ask others for assistance with the builds.
Alternatively, you can request access to the Nix community builder for all platforms [here](https://github.com/NixOS/aarch64-build-box) and [here](https://nix-community.org/community-builder/).

To build all dependent packages, use:

```
nix-review pr <your-pull-request>
```

And to build all important NixOS tests, run:

```
# Replace $version with the actual Nix version
nix-build nixVersions.nix_$version.tests
```

Be sure to also update the `nix-fallback-paths` whenever you do a patch release for `nixVersions.stable`

```
# Replace $version with the actual Nix version
curl https://releases.nixos.org/nix/nix-$version/fallback-paths.nix > nixos/modules/installer/tools/nix-fallback-paths.nix
```

## Major Version Bumps

If you're updating `nixVersions.stable`, follow all the steps mentioned above, but use the **staging** branch for your pull request (or **staging-next** after coordinating with the people in matrix `#staging:nixos.org`)
This is necessary because, at the end of the staging-next cycle, the NixOS tests are built through the [staging-next-small](https://hydra.nixos.org/jobset/nixos/staging-next-small) jobset.
Especially nixos installer test are important to look at here.
