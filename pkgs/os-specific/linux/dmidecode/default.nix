{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dmidecode-3.1";

  src = fetchurl {
    url = "mirror://savannah/dmidecode/${name}.tar.xz";
    sha256 = "1h0sg0lxa15nzf8s7884p6q7p6md9idm0c79wyqmk32l4ndwwrnp";
  };

  makeFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    homepage = http://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
