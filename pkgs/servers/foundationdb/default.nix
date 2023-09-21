{ gccStdenv, llvmPackages
, lib, fetchFromGitHub

, cmake, ninja, python3, openjdk8, mono, openssl, boost178
, pkg-config, msgpack, toml11
}@args:

let
  cmakeBuild = import ./cmake.nix args;
in {
  foundationdb71 = cmakeBuild {
    version = "7.1.32";
    hash    = "sha256-CNJ4w1ECadj2KtcfbBPBQpXQeq9BAiw54hUgRTWPFzY=";
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
