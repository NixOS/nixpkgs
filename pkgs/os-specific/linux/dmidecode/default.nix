{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dmidecode";
  version = "3.5";

  src = fetchurl {
    url = "mirror://savannah/dmidecode/dmidecode-${version}.tar.xz";
    sha256 = "sha256-eddnNe6OJRluKnIpZM+Wg/WglYFQNTeISyVrATicwHM=";
  };

  makeFlags = [
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = with lib; {
    homepage = "https://www.nongnu.org/dmidecode/";
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
