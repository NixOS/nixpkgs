{stdenv, fetchurl, fetchgit, libX11, xproto, libXtst, xextproto, pkgconfig
, inputproto, libXi}:
let
  s = rec {
    baseName = "xcape";
    version = "git-2013-05-30";
    name = "${baseName}-${version}";
  };
  buildInputs = [
    libX11 libXtst xproto xextproto pkgconfig inputproto libXi
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchgit {
    url = https://github.com/alols/xcape;
    rev = "39aa08c5da354a8fe495eba8787a01957cfa5fcb";
    sha256 = "1yh0vbaj4c5lflxm3d4xrfaric1lp0gfcyzq33bqphpsba439bmg";
  };
  preConfigure = ''
    makeFlags="$makeFlags PREFIX=$out"
  '';
  meta = {
    inherit (s) version;
    description = ''A tool to have Escape and Control on a single key'';
    license = stdenv.lib.licenses.gpl3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
