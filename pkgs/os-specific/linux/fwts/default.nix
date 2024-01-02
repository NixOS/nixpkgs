{ lib, stdenv, fetchzip, autoreconfHook, pkg-config, gnumake42, glib, pcre
, json_c, flex, bison, dtc, pciutils, dmidecode, acpica-tools, libbsd }:

stdenv.mkDerivation rec {
  pname = "fwts";
  version = "23.07.00";

  src = fetchzip {
    url = "https://fwts.ubuntu.com/release/${pname}-V${version}.tar.gz";
    sha256 = "sha256-Fo5qdb0eT8taYfPAf5LQu0toNXcoVjNoDgeeAlUfbs4=";
    stripRoot = false;
  };

  # fails with make 4.4
  nativeBuildInputs = [ autoreconfHook pkg-config gnumake42 ];
  buildInputs = [ glib pcre json_c flex bison dtc pciutils dmidecode acpica-tools libbsd ];

  postPatch = ''
    substituteInPlace src/lib/include/fwts_binpaths.h \
      --replace "/usr/bin/lspci"      "${pciutils}/bin/lspci" \
      --replace "/usr/sbin/dmidecode" "${dmidecode}/bin/dmidecode" \
      --replace "/usr/bin/iasl"       "${acpica-tools}/bin/iasl"

    substituteInPlace src/lib/src/fwts_devicetree.c \
                      src/devicetree/dt_base/dt_base.c \
      --replace "dtc -I" "${dtc}/bin/dtc -I"
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
