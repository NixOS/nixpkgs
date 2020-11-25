{ stdenv, fetchurl, intltool, pkgconfig, glib }:

stdenv.mkDerivation {
  name = "gnu-mdk-1.3.0";
  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/mdk/v1.3.0/mdk-1.3.0.tar.gz";
    sha256 = "0bhk3c82kyp8167h71vdpbcr852h5blpnwggcswqqwvvykbms7lb";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib ];
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v ./misc/*.el $out/share/emacs/site-lisp
  '';

  meta = {
    description = "GNU MIX Development Kit (MDK)";
    homepage = "https://www.gnu.org/software/mdk/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
