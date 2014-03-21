{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm, pkgconfig, librsvg, cairo
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.7.3";
    name="${baseName}-${version}";
    hash="1amy9krr0qkvcc7gnp3i9x9ma91fc5cq8hy3gdc7rmfsaczv1l3z";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.7.3.tar.gz";
    sha256="1amy9krr0qkvcc7gnp3i9x9ma91fc5cq8hy3gdc7rmfsaczv1l3z";
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
