{
  callPackage,
  nixosTests,
  fetchpatch,
  ...
}@args:

callPackage ./generic.nix args {
  # You have to ensure that in `pkgs/top-level/linux-kernels.nix`
  # this attribute is the correct one for this package.
  kernelModuleAttribute = "zfs_unstable";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "7.0";

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
  version = "2.4.3";
  # rev = "";

  # if adding a patch here, check if it also needs to be applied to the stable branches
  extraPatches = [
    # https://github.com/openzfs/zfs/issues/18366
    # dedup data corruption fix unreleased as of OpenZFS 2.4.3
    (fetchpatch {
      url = "https://github.com/openzfs/zfs/commit/6fb72fda0f60d9efb591e320f83f78b19ec451cc.patch?full_index=1";
      hash = "sha256-UuSVmO61Ux5S3F+JAtRnHyeVS4EFobDTKBuD5s8PI+k=";
    })
    # backport kernel memory corruption fix
    # https://github.com/openzfs/zfs/issues/18787
    (fetchpatch {
      url = "https://github.com/openzfs/zfs/commit/223b8bc446851e5e796e5446ac24d03bbf468f43.patch?full_index=1";
      hash = "sha256-I29A+NLYLzy7cMC8FQpBdSYbjFu/kscgTW8mAauPVf4=";
    })
  ];

  tests = {
    inherit (nixosTests.zfs) unstable;
  };

  hash = "sha256-I1wLbstr0cFiGsyynP9kJ9ATRp/2b+fnnsdz0up+IzM=";

  extraLongDescription = ''
    This is "unstable" ZFS, and will usually be a pre-release version of ZFS.
    It may be less well-tested and have critical bugs.
  '';
}
