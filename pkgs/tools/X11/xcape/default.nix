{stdenv, fetchurl, fetchgit, libX11, xproto, libXtst, xextproto, pkgconfig
, inputproto, libXi}:
let
  s = rec {
    baseName = "xcape";
    version = "git-2015-03-01";
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
    rev = "f3802fc086ce9d961d644a5d29ad5b650db56215";
    sha256 = "05mm4ap69ncwl4hhzf2dvbazqxjf27477cd3chpfc7qi7srqasvz";
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
