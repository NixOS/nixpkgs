{ stdenv, fetchFromGitHub, gtk3, pkgconfig, intltool, libxslt, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  version = "0.5.4.12";
  name = "xarchiver-${version}";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = "${version}";
    sha256 = "13d8slcx3frz0dhl1w4llj7001n57cjjb8r7dlaw5qacaas3xfwi";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 intltool libxslt hicolor-icon-theme ];

  meta = {
    description = "GTK+ frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = https://github.com/ib/xarchiver;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
