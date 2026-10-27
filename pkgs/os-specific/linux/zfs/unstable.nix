{
  callPackage,
  fetchpatch2,
  nixosTests,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_unstable";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "7.3";

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.4.4";
  # rev = "";

  # if adding a patch here, check if it also needs to be applied to the stable branches
  extraPatches = [
    (fetchpatch2 {
      url = "https://github.com/openzfs/zfs/commit/d966f3dd8c2e4eb04e52227b7a87f5828924f89c.patch?full_index=1";
      hash = "sha256-Oe0JPnMaDrh0tO2x+yJZ90kAba/MUnHgLNK02/uMaw4=";
    })
    (fetchpatch2 {
      url = "https://github.com/openzfs/zfs/commit/cd3699d308e1b37dcdd0d5a9a8c3624deb5fc3e9.patch?full_index=1";
      hash = "sha256-3uqkN0KxcZ1SGI7eBOIvglGy5MxZJgXQO3vUPwcv2co=";
      excludes = [
        "include/os/linux/Makefile.am"
        "module/os/linux/spl/spl-taskq.c"
      ];
    })
    (fetchpatch2 {
      url = "https://github.com/openzfs/zfs/commit/a128b8a075b5b13c737e56914cd7043bd3e9ebf8.patch?full_index=1";
      hash = "sha256-59/TKa+bPAgAfAH9mzJ51npjqO70nBlaEWerMHJcFuM=";
    })
    (fetchpatch2 {
      url = "https://github.com/openzfs/zfs/commit/315bc75afc18f548df3b738b69bfaad7cff094ad.patch?full_index=1";
      hash = "sha256-c/cb6QxdggzeHJx4mggQYc5pshRADMxcZ1hg39JJezQ=";
      excludes = [ "include/os/linux/kernel/linux/simd_x86.h" ];
    })
    ./linux-7.3.patch
  ];

  tests = {
    inherit (nixosTests.zfs) unstable;
  };

  hash = "sha256-ZgfHTPsNoeDq6GKP4Xiti7Keis3vIZLDaTGQjgCItIc=";

  extraLongDescription = ''
    This is "unstable" ZFS, and will usually be a pre-release version of ZFS.
    It may be less well-tested and have critical bugs.
  '';
}
