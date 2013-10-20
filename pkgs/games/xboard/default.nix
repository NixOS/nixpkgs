{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm, pkgconfig, librsvg, cairo
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.7.2";
    name="${baseName}-${version}";
    hash="1vm95fjp3pkvvjvamfs7zqw4l4b4v7v52h2npvf9j5059fckcrwv";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.7.2.tar.gz";
    sha256="1vm95fjp3pkvvjvamfs7zqw4l4b4v7v52h2npvf9j5059fckcrwv";
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
