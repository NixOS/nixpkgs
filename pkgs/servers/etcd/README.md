# etcd


## Upstream release cadence and support

The etcd project maintains release branches for the current version and previous release.

For example, when v3.5 is the current version, v3.4 is supported. When v3.6 is released, v3.4 goes out of support.

Reference: https://etcd.io/docs/v3.5/op-guide/versioning/


## NixOS release and etcd version upkeep

Every major/minor version bump of `etcd` top-level alias in nixpkgs requires a notification in the next NixOS release notes scheduling the removal of the now unsupported etcd version.

After every NixOS release, the unsupported etcd versions should be removed by etcd maintainers.


## User guidelines on etcd upgrades

Before upgrading a NixOS release, certify to upgrade etcd to the latest version in the current used release.

Manual steps might be required for the upgrade.

NixOS release notes might have instructions on how to proceed on upgrades.
