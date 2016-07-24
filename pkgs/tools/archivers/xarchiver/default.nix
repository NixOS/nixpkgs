{ stdenv, fetchFromGitHub, gtk, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  version = "0.5.4.7";
  name = "xarchiver-${version}";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = "${name}";
    sha256 = "0w9lx8d8r50j48qfhn2r0dlcnwy3pjyy6xjvgpr0qagy5l1q1qj4";
  };

  buildInputs = [ gtk pkgconfig intltool ];

  meta = {
    description = "GTK+ frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = https://github.com/ib/xarchiver;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
