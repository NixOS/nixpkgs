{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dmidecode-3.2";

  src = fetchurl {
    url = "mirror://savannah/dmidecode/${name}.tar.xz";
    sha256 = "1pcfhcgs2ifdjwp7amnsr3lq95pgxpr150bjhdinvl505px0cw07";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
