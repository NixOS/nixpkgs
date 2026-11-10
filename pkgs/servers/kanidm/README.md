# Kanidm release guide

Kanidm supports one release at any given time, with a 30-day overlap to allow for upgrades from old to new version.
Version upgrades are only supported on adjacent releases, with no support for jumping versions.

To ensure we provide sufficient coverage for upgrading, we will aim to have two or three releases in tree at any given time.
Unsupported versions will be marked as vulnerable (lacking an "unsupported" mechanism), but built by hydra to avoid pushing the very large rebuild on users.

It is expected that stable users will have to manually specify the version, and update that version, throughout the lifecycle of a NixOS release.

## New release

For example, when upgrading from 1.11 to 1.12:

### Init new version

```sh
./pkgs/servers/kanidm/release.py new-release 1.12 [--commit]
```

Latest point release will be found, eolDate for previous version computed from .0 release.

## Remove release

### Mark unsupported and backport

```sh
./pkgs/servers/kanidm/release.py mark-unsupported 1.11 [--commit]
```

Create(s) commit `kanidm_1_11: mark EOL`; this commit alone should be backported.

### Cleanup master

Retain the two newest releases for adjacent upgrades. Remove older releases explicitly:

```sh
./pkgs/servers/kanidm/release.py remove-release 1.10 [--commit]
```

Do not backport
