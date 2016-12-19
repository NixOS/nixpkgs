{ stdenv, fetchurl, perl, php, gd, libpng, zlib, unzip }:

stdenv.mkDerivation rec {
  name = "nagios-${version}";
  version = "4.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/nagios/nagios-4.x/${name}/${name}.tar.gz";
    sha256 = "0p16sm5pkbzf4py30hwzm38194cl23wfzsvkhk4jkf3p1fq7xvl3";
  };

  patches = [ ./nagios.patch ];
  buildInputs = [ php perl gd libpng zlib unzip ];

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
