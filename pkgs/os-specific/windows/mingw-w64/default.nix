{ lib, stdenv, windows, fetchurl }:

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

  meta = {
    platforms = lib.platforms.windows;
  };
}
