{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpi-1.5";
  
  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/a/acpi/acpi_1.5.orig.tar.gz";
    sha256 = "1pb020j627ldjm1askqfzp6cjxrs79ail8svihanv7pgbg5r3zsp";
  };

  meta = {
    longDescription = ''
      Linux ACPI client is a small command-line
      program that attempts to replicate the functionality of
      the "old" `apm' command on ACPI systems.  It includes
      battery and thermal information.
    '';
    homepage = http://grahame.angrygoats.net/acpi.shtml;
    license = "GPLv2+";
  };
}
