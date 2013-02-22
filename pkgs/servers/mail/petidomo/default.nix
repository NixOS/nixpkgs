{ stdenv, fetchurl, flex, bison, sendmailPath ? "/var/setuid-wrappers/sendmail" }:

stdenv.mkDerivation rec {
  name = "petidomo-4.3";

  src = fetchurl {
    url = "mirror://sourceforge/petidomo/${name}.tar.gz";
    sha256 = "0x4dbxc4fcfg1rw5ywpcypvylnzn3y4rh0m6fz4h4cdnzb8p1lvm";
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
