# Kanidm release guide

Kanidm supports one release at any given time, with a 30-day overlap to allow for upgrades from old to new version.
Version upgrades are only supported on adjacent releases, with no support for jumping versions.

To ensure we provide sufficient coverage for upgrading, we will aim to have two or three releases in tree at any given time.
Unsupported versions will be marked as vulnerable (lacking an "unsupported" mechanism), but built by hydra to avoid pushing the very large rebuild on users.

The default version will be updated with each new version, but the default will not be backported.
It is expected that stable users will have to manually specify the version, and update that version, throughout the lifecycle of a NixOS release.

## New release

For example, when upgrading from 1.4 -> 1.5

### Init new version

1. `cp pkgs/by-name/ka/kanidm/1_4.nix pkgs/by-name/ka/kanidm/1_5.nix`
1. `cp -r pkgs/by-name/ka/kanidm/patches/1_4 pkgs/by-name/ka/kanidm/patches/1_5`
1. Update `1_5.nix` hashes/paths, and as needed for upstream changes, `generic.nix`
1. Update `all-packages.nix` to add `kanidm_1_5` and `kanidmWithSecretProvisioning_1_5`, leave default
1. Update the previous release, e.g. `1_4.nix` and set `eolDate = "YYYY-MM-DD"` where the date is 30 days from release of 1.5.
1. Create commit, `kanidm_1_5: init at 1.5.0` - this is the only commit that will be backported

### Update default

1. Update kanidm aliases in `aliases.nix`. Should remove completely after 25.11 branch off.
1. Create commit `kanidm: update default to 1.5.0`

### Backport to stable

1. Manually create a backport using _only_ the init commit

## Remove release

Kanidm versions are supported for 30 days after the release of new versions. Following the example above, 1.5.x superseding 1.4.x in 30 days, do the following near the end of the 30-day window

1. Update `pkgs/by-name/ka/kanidm/1_4.nix` by adding `unsupported = true;`
1. Update `pkgs/top-level/release.nix` and add `kanidm_1_4-1.4.6` and `kanidmWithSecretProvisioning_1_4-1.4.6` to `permittedInsecurePackages`
1. Create commit `kanidm_1_4: mark EOL`, this commit alone should be backported

1. Remove the third oldest release from `all-packages.nix`, e.g. 1.3.x continuing the example. Remove `kanidm_1_3` and `kanidmWithSecretProvisioning_1_3`
1. Update `pkgs/top-level/release.nix` and remove `kanidm_1_3*` from `permittedInsecurePackages`
1. Update `pkgs/top-level/aliases.nix` and add `kanidm_1_4` and `kanidmWithSecretProvisioning_1_4-1.4.6`
1. Remove `pkgs/by-name/ka/kanidm/1_3.nix`
