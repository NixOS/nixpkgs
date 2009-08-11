{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "dmidecode-2.10";

  src = fetchurl {
    url = "http://www.very-clever.com/download/nongnu/dmidecode/${name}.tar.bz2";
    sha256 = "1h72r5scrpvgw60hif5msjg6vw2x0jd6z094lhbh6cjk6gls6x2d";
  };

  makeFlags = "prefix=$(out)";

  meta = {
    homepage = http://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
  };
}
