{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "mailman-2.1.17";

  src = fetchurl {
    url = "mirror://gnu/mailman/${name}.tgz";
    sha256 = "1rws4ghpq78ldp1si3z4pmiv1k4l8g6i6hjb2y4cwsjlxssahc64";
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
