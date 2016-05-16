{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm, pkgconfig, librsvg, cairo, pango
, gtk2
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.9.0";
    name="${baseName}-${version}";
    hash="1av6r3s5vyclwf3c9i1pkr2442ryrf4ixhhf2i44a4j1xyhlp5jb";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.9.0.tar.gz";
    sha256="1av6r3s5vyclwf3c9i1pkr2442ryrf4ixhhf2i44a4j1xyhlp5jb";
  };
  buildInputs = [
    libX11 xproto libXt libXaw libSM libICE libXmu 
    libXext gnuchess texinfo libXpm pkgconfig librsvg 
    cairo pango gtk2
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
