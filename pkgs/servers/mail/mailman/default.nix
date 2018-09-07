{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "mailman-${version}";
  version = "2.1.24";

  src = fetchurl {
    url = "mirror://gnu/mailman/${name}.tgz";
    sha256 = "1r6sjapjmbav45xibjzc2a8y1xf4ikz09470ma1kw7iz174wn8z7";
  };

  buildInputs = [ python2 python2.pkgs.dnspython ];

  patches = [ ./fix-var-prefix.patch ];

  configureFlags = [
    "--without-permcheck"
    "--with-cgi-ext=.cgi"
    "--with-var-prefix=/var/lib/mailman"
  ];

  installTargets = "doinstall"; # Leave out the 'update' target that's implied by 'install'.

  makeFlags = [ "DIRSETGID=:" ];

  meta = {
    homepage = http://www.gnu.org/software/mailman/;
    description = "Free software for managing electronic mail discussion and e-newsletter lists";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
