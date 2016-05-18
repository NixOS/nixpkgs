{ stdenv, fetchurl, python, pythonPackages }:

stdenv.mkDerivation rec {
  name = "mailman-2.1.18";

  src = fetchurl {
    url = "mirror://gnu/mailman/${name}.tgz";
    sha256 = "0jc360crakvpz71msl0h11zv3849fqzlj9jfh1g7x3j4459n07fw";
  };

  buildInputs = [ python pythonPackages.dns ];

  patches = [ ./fix-var-prefix.patch ];

  configureFlags = "--without-permcheck --with-cgi-ext=.cgi --with-var-prefix=/var/lib/mailman";

  installTargets = "doinstall";         # Leave out the 'update' target that's implied by 'install'.

  meta = {
    homepage = "http://www.gnu.org/software/mailman/";
    description = "Free software for managing electronic mail discussion and e-newsletter lists";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
