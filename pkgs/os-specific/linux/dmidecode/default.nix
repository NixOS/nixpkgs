{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dmidecode-2.11";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/dmidecode/${name}.tar.bz2";
    sha256 = "0l9v8985piykc98hmbg1cq5r4xwvp0jjl4li3avr3ddkg4s699bd";
  };

  makeFlags = "prefix=$(out)";

  meta = {
    homepage = http://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
  };
}
