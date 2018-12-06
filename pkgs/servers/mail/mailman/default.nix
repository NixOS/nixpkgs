{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "mailman-${version}";
  version = "2.1.29";

  src = fetchurl {
    url = "mirror://gnu/mailman/${name}.tgz";
    sha256 = "0b0dpwf6ap260791c7lg2vpw30llf19hymbf2hja3s016rqp5243";
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
    homepage = https://www.gnu.org/software/mailman/;
    description = "Free software for managing electronic mail discussion and e-newsletter lists";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
