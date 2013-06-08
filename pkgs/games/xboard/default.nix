{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm, pkgconfig, librsvg, cairo
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.7.1";
    name="${baseName}-${version}";
    hash="0hnav2swswaf0463c4wnmgwaif3g42f2a1mqyqc5fa1py32iy6ry";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.7.1.tar.gz";
    sha256="0hnav2swswaf0463c4wnmgwaif3g42f2a1mqyqc5fa1py32iy6ry";
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
