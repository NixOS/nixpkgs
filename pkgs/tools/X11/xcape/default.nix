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
    sha256 = "0d79riwzmjr621ss3yhxqn2q8chn3f9rvk2nnjckz5yxbifvfg9s";
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
