{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dmidecode-2.12";

  src = fetchurl {
    url = "mirror://savannah/dmidecode/${name}.tar.bz2";
    sha256 = "122hgaw8mpqdfra159lfl6pyk3837giqx6vq42j64fjnbl2z6gwi";
  };

  makeFlags = "prefix=$(out)";

  meta = {
    homepage = http://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
  };
}
