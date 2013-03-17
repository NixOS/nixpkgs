{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm, pkgconfig, librsvg, cairo
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.7.0";
    name="${baseName}-${version}";
    hash="15azbnyfapjppfni9k99sk68af1kg60nnh95rz8jgb3i2xv5y5m7";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.7.0.tar.gz";
    sha256="15azbnyfapjppfni9k99sk68af1kg60nnh95rz8jgb3i2xv5y5m7";
  };
  buildInputs = [
    libX11 xproto libXt libXaw libSM libICE libXmu 
    libXext gnuchess texinfo libXpm pkgconfig librsvg 
    cairo
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''GUI for chess engines'';
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
