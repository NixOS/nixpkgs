{stdenv, fetchurl, pkgconfig, glib, gperf, utillinux}:
let
  s = # Generated upstream information
  rec {
    baseName="eudev";
    version="2.1.1";
    name="${baseName}-${version}";
    url="http://dev.gentoo.org/~blueness/eudev/eudev-${version}.tar.gz";
    sha256="0shf5vqiz9fdxl95aa1a8vh0xjxwim3psc39wr2xr8lnahf11vva";
  };
  buildInputs = [
    glib pkgconfig gperf utillinux
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
    description = ''An udev fork by Gentoo'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = ''http://www.gentoo.org/proj/en/eudev/'';
    downloadPage = ''http://dev.gentoo.org/~blueness/eudev/'';
    updateWalker = true;
  };
}
