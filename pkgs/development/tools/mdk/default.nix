{ stdenv, fetchurl, intltool, pkgconfig, glib }:

stdenv.mkDerivation {
  name = "gnu-mdk-1.2.10";
  src = fetchurl {
    url = https://ftp.gnu.org/gnu/mdk/v1.2.10/mdk-1.2.10.tar.gz;
    sha256 = "1rwcq2b5vvv7318j92nxc5dayj27dpfhzc4rjiv4ccvsc0x35x5h";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib ];
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v ./misc/*.el $out/share/emacs/site-lisp
  '';

  meta = {
    description = "GNU MIX Development Kit (MDK)";
    homepage = https://www.gnu.org/software/mdk/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
