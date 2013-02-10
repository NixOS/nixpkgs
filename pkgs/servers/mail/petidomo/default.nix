{ stdenv, fetchurl, flex, bison, sendmailPath ? "/var/setuid-wrappers/sendmail" }:

stdenv.mkDerivation rec {
  name = "petidomo-4.2";

  src = fetchurl {
    url = "mirror://sourceforge/petidomo/${name}.tar.gz";
    sha256 = "0rckzsiqg819ids5784gmlf5p1lbjvavz0f5mwn10h34kclhi8bz";
  };

  buildInputs = [ flex bison ];

  configureFlags = "--with-mta=${sendmailPath}";

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = "http://petidomo.sourceforge.net/";
    description = "a simple and easy to administer mailing list server";
    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
