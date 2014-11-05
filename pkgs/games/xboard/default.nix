{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm, pkgconfig, librsvg, cairo
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.8.0";
    name="${baseName}-${version}";
    hash="05rdj0nyirc4g1qi5hhrjy45y52ihp1j3ldq2c5bwrz0gzy4i3y8";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.8.0.tar.gz";
    sha256="05rdj0nyirc4g1qi5hhrjy45y52ihp1j3ldq2c5bwrz0gzy4i3y8";
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
