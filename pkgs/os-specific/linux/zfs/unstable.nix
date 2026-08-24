{
  callPackage,
  nixosTests,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_unstable";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "7.2";

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.4.4";
  # rev = "";

  # if adding a patch here, check if it also needs to be applied to the stable branches
  extraPatches = [ ];

  tests = {
    inherit (nixosTests.zfs) unstable;
  };

  hash = "sha256-ZgfHTPsNoeDq6GKP4Xiti7Keis3vIZLDaTGQjgCItIc=";

  extraLongDescription = ''
    This is "unstable" ZFS, and will usually be a pre-release version of ZFS.
    It may be less well-tested and have critical bugs.
  '';
}
