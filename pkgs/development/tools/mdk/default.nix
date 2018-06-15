{ stdenv, fetchurl, intltool, pkgconfig, glib }:

stdenv.mkDerivation {
  name = "gnu-mdk-1.2.9";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/mdk/v1.2.9/mdk-1.2.9.tar.gz;
    sha256 = "0c24wzrzbk0l4z1p5nnxihaqra75amwmw59va44554infkfms9kc";
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
