{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dmidecode-3.0";

  src = fetchurl {
    url = "mirror://savannah/dmidecode/${name}.tar.xz";
    sha256 = "0iby0xfk5x3cdr0x0gxj5888jjyjhafvaq0l79civ73jjfqmphvy";
  };

  makeFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    homepage = http://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
    platforms = platforms.linux;
  };
}
