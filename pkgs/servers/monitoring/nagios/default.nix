{ stdenv, fetchurl, perl, php, gd, libpng, zlib }:

stdenv.mkDerivation {
  name = "nagios-4.0.7";

  src = fetchurl {
    url = mirror://sourceforge/nagios/nagios-4.x/nagios-4.0.7/nagios-4.0.7.tar.gz;
    sha256 = "1687qnbsag84r57y9745g2klypacfixd6gkzaj42lmzn0v8y27gg";
  };

  patches = [ ./nagios.patch ];
  buildInputs = [ php perl gd libpng zlib ];

  configureFlags = [ "--localstatedir=/var/lib/nagios" ];
  buildFlags = "all";

  # Do not create /var directories
  preInstall = ''
    substituteInPlace Makefile --replace '$(MAKE) install-basic' ""
  '';
  installTargets = "install install-config";

  meta = {
    description = "A host, service and network monitoring program";
    homepage    = http://www.nagios.org/;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice relrod ];
  };
}
