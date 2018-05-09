{ callPackage, binutils, gccCrossStageStatic, gccCrossMingw2, buildEnv
, crossLibcStdenv }:

rec {
  cygwinSetup = callPackage ./cygwin-setup { };

  jom = callPackage ./jom { };

  w32api = callPackage ./w32api {
    gccCross = gccCrossStageStatic;
    binutils = binutils;
  };

  w32api_headers = w32api.override {
    onlyHeaders = true;
  };

  mingw_runtime = callPackage ./mingwrt {
    gccCross = gccCrossMingw2;
    binutils = binutils;
  };

  mingw_runtime_headers = mingw_runtime.override {
    onlyHeaders = true;
  };

  mingw_headers1 = buildEnv {
    name = "mingw-headers-1";
    paths = [ w32api_headers mingw_runtime_headers ];
  };

  mingw_headers2 = buildEnv {
    name = "mingw-headers-2";
    paths = [ w32api mingw_runtime_headers ];
  };

  mingw_headers3 = buildEnv {
    name = "mingw-headers-3";
    paths = [ w32api mingw_runtime ];
  };

  mingw_w64 = callPackage ./mingw-w64 {
    stdenv = crossLibcStdenv;
  };

  mingw_w64_headers = callPackage ./mingw-w64/headers.nix { };

  mingw_w64_pthreads = callPackage ./mingw-w64/pthreads.nix { };

  pthreads = callPackage ./pthread-w32 {
    mingw_headers = mingw_headers3;
  };

  wxMSW = callPackage ./wxMSW-2.8 { };
}
