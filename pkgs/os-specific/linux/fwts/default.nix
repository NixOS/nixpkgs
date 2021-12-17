{ lib, stdenv, fetchzip, autoreconfHook, pkg-config, glib, pcre
, json_c, flex, bison, dtc, pciutils, dmidecode, acpica-tools, libbsd }:

stdenv.mkDerivation rec {
  pname = "fwts";
  version = "21.07.00";

  src = fetchzip {
    url = "https://fwts.ubuntu.com/release/${pname}-V${version}.tar.gz";
    sha256 = "sha256-cTm8R7sUJk5aTjXvsxfBXX0J/ehVoqo43ILZ6VqaPTI=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ glib pcre json_c flex bison dtc pciutils dmidecode acpica-tools libbsd ];

  postPatch = ''
    substituteInPlace src/lib/include/fwts_binpaths.h \
      --replace "/usr/bin/lspci"      "${pciutils}/bin/lspci" \
      --replace "/usr/sbin/dmidecode" "${dmidecode}/bin/dmidecode" \
      --replace "/usr/bin/iasl"       "${acpica-tools}/bin/iasl"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://wiki.ubuntu.com/FirmwareTestSuite";
    description = "Firmware Test Suite";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ tadfisher ];
  };
}
