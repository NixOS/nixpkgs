{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pmtools-20071116";

  src = fetchurl {
    url = "http://www.lesswatts.org/patches/linux_acpi/${name}.tar.gz";
    sha256 = "91751774976e39f6237efd0326eb35196a9346220b92ad35894a33283e872748";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/pmtools
    cp acpidump/acpidump acpixtract/acpixtract madt/madt $out/bin/
    cp README $out/share/pmtools/
  '';

  meta = {
    homepage = http://www.lesswatts.org/projects/acpi/utilities.php;
    description = "Linux ACPI utilities";
    license = "GPLv2";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
