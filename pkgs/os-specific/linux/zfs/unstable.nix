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
<<<<<<< HEAD
  kernelMaxSupportedMajorMinor = "6.18";
=======
  kernelMaxSupportedMajorMinor = "6.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # this package should point to a version / git revision compatible with the latest kernel release
  # IMPORTANT: Always use a tagged release candidate or commits from the
  # zfs-<version>-staging branch, because this is tested by the OpenZFS
  # maintainers.
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.4.0-rc4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # rev = "";

  tests = {
    inherit (nixosTests.zfs) unstable;
  };

<<<<<<< HEAD
  hash = "sha256-v78Tn1Im9h8Sjd4XACYesPOD+hlUR3Cmg8XjcJXOuwM=";
=======
  hash = "sha256-PEKIGE6pB+Vs034wDa20s3aMmIIWmOD8yWizseO3fq0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  extraLongDescription = ''
    This is "unstable" ZFS, and will usually be a pre-release version of ZFS.
    It may be less well-tested and have critical bugs.
  '';
}
