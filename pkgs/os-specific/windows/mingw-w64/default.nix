{ lib, stdenv, windows, fetchurl, fetchpatch }:

let
  version = "6.0.0";
in stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "1w28mynv500y03h92nh87rgw3fnp82qwnjbxrrzqkmr63q812pl0";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
  ];

  enableParallelBuilding = true;

  buildInputs = [ windows.mingw_w64_headers ];
  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];
  patches = [
    # Clang support https://github.com/mstorsjo/llvm-mingw/issues/3
    (fetchpatch {
      url = "https://github.com/mirror/mingw-w64/commit/25d51481e344be35d93524965309f514486395c0.diff";
      sha256 = "09rgzyg95kp5sh1zikcjh0h616ni38n8vzf03x6s8hqj07692y4i";
    })
  ];

  enableParallelBuilding = true;

  meta = {
    platforms = lib.platforms.windows;
  };
}
