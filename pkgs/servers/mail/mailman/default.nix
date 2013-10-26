{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "mailman-2.1.16";

  src = fetchurl {
    url = "mirror://gnu/mailman/${name}.tgz";
    sha256 = "0qsgnqjfi07kdiwzik0i78a5q3q5kcw1r61g48abix9qjc32n5ax";
  };

  buildInputs = [ python ];

  patches = [ ./fix-var-prefix.patch ];

  configureFlags = "--without-permcheck --with-cgi-ext=.cgi --with-var-prefix=/var/lib/mailman";

  installTargets = "doinstall";         # Leave out the 'update' target that's implied by 'install'.

  meta = {
    homepage = "http://www.gnu.org/software/mailman/";
    description = "Free software for managing electronic mail discussion and e-newsletter lists";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
