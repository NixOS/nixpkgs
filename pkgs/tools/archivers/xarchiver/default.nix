{ stdenv, fetchFromGitHub, fetchpatch, gtk3, pkgconfig, intltool, libxslt, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  version = "0.5.4.12";
  name = "xarchiver-${version}";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = "${version}";
    sha256 = "13d8slcx3frz0dhl1w4llj7001n57cjjb8r7dlaw5qacaas3xfwi";
  };

  patches = [
    # Fixes darwin build, remove with next update.
    (fetchpatch {
      url = https://github.com/ib/xarchiver/commit/8c69d066a827419feafd0bd047d19207ceadc7df.patch;
      sha256 = "1ch1409hx1ynkm0mz93zy8h7wvcrsn56sz7lczsf6hznc8yzl0qg";
    })
  ];

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
