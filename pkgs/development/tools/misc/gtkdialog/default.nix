{lib, stdenv, fetchurl, gtk2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "gtkdialog";
  version = "0.8.3";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "ff89d2d7f1e6488e5df5f895716ac1d4198c2467a2a5dc1f51ab408a2faec38e";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  meta = {
    homepage = "https://code.google.com/archive/p/gtkdialog/";
    # community links: http://murga-linux.com/puppy/viewtopic.php?t=111923 -> https://github.com/01micko/gtkdialog
    description = "Small utility for fast and easy GUI building from many scripted and compiled languages";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
