# NVIDIA driver packages

The drivers are built from the files here. `default.nix` is a factory: called
without a kernel it returns the userspace half of every driver branch, and
`linuxPackages` calls it again with one to get the kernel modules too.

```nix
{
  # from default.nix, no kernel: the userspace half
  driver = pkgs.nvidiaPackages.production.driver;

  # the same factory, with a kernel: the same driver, plus the modules
  kernelModule = pkgs.linuxPackages.nvidiaPackages.production.mod;
}
```

`nvidiaPackages` is a `lib.makeScope` set, so a whole new branch can be added
with `overrideScope`. A branch is a `lib.makeExtensible` set and holds:

| attribute       | what it is                                                     |
| --------------- | -------------------------------------------------------------- |
| `branch`        | the branch name, e.g. `production`                             |
| `version`       | the driver version                                             |
| `driver`        | the driver package: `out`, `bin`, `firmware`, `lib32` outputs |
| `settings`      | nvidia-settings, with `libXNVCtrl` in its `passthru`           |
| `modprobe`      | nvidia-modprobe                                                |
| `persistenced`  | nvidia-persistenced                                            |
| `fabricmanager` | nv-fabricmanager, on the data center branches only             |
| `mod`, `open`   | the kernel modules, only from `linuxPackages`                  |

`out`, `bin`, `firmware` and `lib32` warn and hand back the driver's own output
or `passthru` entry of that name; `modsrc` throws. Where the driver has no such
name the alias throws instead, naming the branch: `legacy_340`, `legacy_390` and
`legacy_470` have no `firmware`, and no branch has `lib32` on a host that builds
no i686, such as aarch64.

They are there only while `config.allowAliases` is on, which is the default. The
release and eval configurations turn it off, so the walk that turns each package
into a job never sees them.

Hydra builds the userspace branches under `pkgs.nvidiaPackages`, and the kernel
modules under `linuxPackages.nvidiaModules`. That second path exists only so the
release walk can find the modules; the branches under
`linuxPackages.nvidiaPackages` are the interface, and its userspace members are
the same derivations as the top-level ones, so they are not jobs of their own.

`nvidiaPackages.mkDriver` builds a branch that is not in nixpkgs.

## Adding or updating a driver in nixpkgs

Add an entry to `default.nix`, or change the hashes of an existing one:

```nix
{
  production = mkBranch {
    version = "595.104.02";
    sha256_64bit = "sha256-...";
    sha256_aarch64 = "sha256-...";
    openSha256 = "sha256-...";
    fetchOpenFromNvidia = true;
    settingsSha256 = "sha256-...";
    persistencedSha256 = "sha256-...";
    modprobeSha256 = "sha256-...";
  };
}
```

`version` and `sha256_64bit` are required. The rest are optional and select
the sources a branch ships:

- `sha256_32bit` adds the i686 driver archive. Drivers older than 391 need it.
- `sha256_aarch64` adds the aarch64 driver archive.
- `openSha256` enables the open kernel modules. `fetchOpenFromNvidia` also
  lists the NVIDIA-hosted tarball next to the GitHub archive.
- `modprobeSha256` enables `nvidia-modprobe`. `settingsSha256` and
  `persistencedSha256` are required for nvidia-settings and
  nvidia-persistenced, which are on unless `useSettings` or `usePersistenced`
  is set to `false`. `fabricmanagerSha256` only matters together with
  `useFabricmanager = true`, which the data center entries set.
  `settingsVersion`, `persistencedVersion`, `fabricmanagerVersion` and
  `modprobeVersion` default to `version` and only need to be set when a
  component follows another version, as `vulkan_beta` does.
- `url` overrides the binary driver URL instead of deriving it from `version`.
  `vulkan_beta` and the data center drivers use it.

The `open`, `modprobe`, `settings` and `persistenced` sources go through
`fetchFromGithubOrNvidia`: the GitHub archive is tried first, the NVIDIA-hosted
tarball is the fallback, and one hash covers both. The open kernel module
source removes `.github` and `CHANGELOG.md` in `postFetch` before hashing,
because the two archives do not ship the same files. The binary driver and the
fabricmanager archive use a plain `fetchurl`.

After a version change the hashes change too. Update them with the helper
script in `maintainers/scripts/nvidia-source-hashes`, or by building and
reading the mismatch error (see the next section).

Adding a legacy driver also means adding a `nvidia_x11_legacy*` entry to the
rename map in `pkgs/top-level/linux-kernels.nix`, so the old name warns with the
replacement.

## Getting and checking hashes

`maintainers/scripts/nvidia-source-hashes/verify.sh` covers every URL of every
source in `linuxPackages.nvidiaPackages`. Run it from the nixpkgs checkout.

```sh
# print the hash that each URL serves, for the sources of one driver
./maintainers/scripts/nvidia-source-hashes/verify.sh --prefetch --path beta

# check the hashes already declared in nixpkgs
./maintainers/scripts/nvidia-source-hashes/verify.sh --path beta

# list the checks without downloading anything
./maintainers/scripts/nvidia-source-hashes/verify.sh --list
```

`--prefetch` downloads the selected URLs and prints the hash each one yields.
The hash is computed the way nixpkgs computes it: the unpacked tree for the
`fetchzip` sources, and after `postFetch` for the open kernel modules. Paste
the printed value into the matching hash field. One hash covers all URLs of a
source, so the values printed for those URLs must match.

Without `--prefetch` the script checks the declared hashes and reports any
mismatch. `--path` filters by component path, such as `production` or `open`.
`--systems` restricts the platforms, and `--list` shows what would run without
downloading.

Each URL is tested on its own. A normal build stops at the first URL that
works, so it never notices a hash that only matches one of them.

A URL that does not exist yet is reported separately and does not fail the run,
because GitHub and NVIDIA publish the same release at different times. Pass
`--strict` to treat it as a failure.

## Using a custom driver version in your configuration

For a version that is not in nixpkgs, call `mkDriver` from your configuration,
from the kernel's own package set so that the kernel modules come from the same
sources:

```nix
{ config, ... }:
{
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "595.104.02";
    sha256_64bit = "";
    sha256_aarch64 = "";
    openSha256 = "";
    fetchOpenFromNvidia = true;
    settingsSha256 = "";
    persistencedSha256 = "";
    modprobeSha256 = "";
  };

  # `hardware.nvidia.kernelModules` follows automatically, looking the branch
  # up in `config.boot.kernelPackages.nvidiaPackages`.
}
```

Leave a hash you do not have as `""`, or set it to `lib.fakeHash` when `lib` is
in scope. Either way Nix fetches the source, fails the fixed-output check, and
prints the hash it got:

```
error: hash mismatch in fixed-output derivation '...':
         specified: sha256-AAAA...=
            got:    sha256-...
```

Copy the `got` value into the matching argument and build again. Repeat for
each component your configuration builds. The binary driver needs
`sha256_64bit`; `settingsSha256` and `persistencedSha256` are needed unless you
set `useSettings = false` or `usePersistenced = false`.

`sha256_aarch64` is only used for aarch64 builds. `sha256_32bit` also matters
on x86_64 for drivers older than 391: their `lib32` is the i686 build of the
`Linux-x86` archive, and `hardware.graphics.enable32Bit` puts that output into
`extraPackages32`.

With `fetchOpenFromNvidia = true` the open sources list two URLs and the single
`openSha256` has to match both, so use the hash from whichever URL your network
can reach. The helper script checks every URL of a source on its own: a URL
that returns 404 is reported as not published and does not fail the run unless
`--strict` is given, while a source whose URLs all return 404 fails.

`hardware.nvidia.open` selects the open kernel modules, which
`hardware.nvidia.kernelModules` then picks up from the branch.
