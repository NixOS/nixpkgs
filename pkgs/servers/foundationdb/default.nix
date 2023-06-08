{ gccStdenv, llvmPackages
, lib, fetchFromGitHub

, cmake, ninja, python3, openjdk8, mono, openssl, boost178
, pkg-config, msgpack, toml11
}@args:

let
  cmakeBuild = import ./cmake.nix args;
in {
  foundationdb71 = cmakeBuild {
    version = "7.1.30";
    sha256  = "sha256-dAnAE1m2NZLHgP4QJvURBPcxArXvWWdhqEYwh3tU+tU";
    boost   = boost178;
    ssl     = openssl;

    patches = [
      ./patches/disable-flowbench.patch
      ./patches/don-t-run-tests-requiring-doctest.patch
      ./patches/don-t-use-static-boost-libs.patch
      ./patches/fix-open-with-O_CREAT.patch
    ];
  };
}
