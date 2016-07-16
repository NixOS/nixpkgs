{ stdenv, fetchFromGitHub, gtk, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  version = "0.5.4.6";
  name = "xarchiver-${version}";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = "${name}";
    sha256 = "1w6b4cchd4prswrn981a7bkq44ad51xm2qiwlpzy43ynql14q877";
  };

  buildInputs = [ gtk pkgconfig intltool ];

  meta = {
    description = "GTK+ frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = http://sourceforge.net/projects/xarchiver/;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
