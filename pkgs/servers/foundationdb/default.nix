{
  gccStdenv,
  llvmPackages,
  lib,
  fetchFromGitHub,
  fetchpatch,

  cmake,
  ninja,
  python3,
  openjdk,
  mono,
  openssl,
  boost,
  pkg-config,
  msgpack-cxx,
  toml11,
  jemalloc,
  doctest,
}@args:

let
  cmakeBuild = import ./cmake.nix args;
in
{
  foundationdb73 = cmakeBuild {
    version = "7.3.42";
    hash = "sha256-jQcm+HLai5da2pZZ7iLdN6fpQZxf5+/kkfv9OSXQ57c=";
    inherit boost;
    ssl = openssl;

    patches = [
      ./patches/disable-flowbench.patch
      ./patches/don-t-use-static-boost-libs.patch
      # GetMsgpack: add 4+ versions of upstream
      # https://github.com/apple/foundationdb/pull/10935
      (fetchpatch {
        url = "https://github.com/apple/foundationdb/commit/c35a23d3f6b65698c3b888d76de2d93a725bff9c.patch";
        hash = "sha256-bneRoZvCzJp0Hp/G0SzAyUyuDrWErSpzv+ickZQJR5w=";
      })
    ];
  };
}
