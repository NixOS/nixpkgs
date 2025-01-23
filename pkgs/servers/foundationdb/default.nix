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
  boost186,
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
    boost = boost186;
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
      # Add a dependency that prevents bindingtester to run before the python bindings are generated
      # https://github.com/apple/foundationdb/pull/11859
      (fetchpatch {
        url = "https://github.com/apple/foundationdb/commit/8d04c97a74c6b83dd8aa6ff5af67587044c2a572.patch";
        hash = "sha256-ZLIcmcfirm1+96DtTIr53HfM5z38uTLZrRNHAmZL6rc=";
      })
    ];
  };
}
