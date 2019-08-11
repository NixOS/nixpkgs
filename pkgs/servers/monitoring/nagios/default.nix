{ stdenv, fetchurl, perl, php, gd, libpng, zlib, unzip }:

stdenv.mkDerivation rec {
  name = "nagios-${version}";
  version = "4.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/nagios/nagios-4.x/${name}/${name}.tar.gz";
    sha256 = "0nkbv8lzpiknddiq0466dlpp3hw8lqmaidk8931hp4664cdsaw57";
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
    homepage    = https://www.nagios.org/;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice relrod ];
  };
}
