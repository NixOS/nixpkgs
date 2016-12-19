{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm, pkgconfig, librsvg, cairo, pango
, gtk2
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.9.1";
    name="${baseName}-${version}";
    hash="1mkh36xnnacnz9r00b5f9ld9309k32jv6mcavklbdnca8bl56bib";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz";
    sha256="1mkh36xnnacnz9r00b5f9ld9309k32jv6mcavklbdnca8bl56bib";
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
