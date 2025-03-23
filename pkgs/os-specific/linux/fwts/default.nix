{
  lib,
  stdenv,
  fetchzip,
  autoreconfHook,
  pkg-config,
  glib,
  pcre,
  json_c,
  flex,
  bison,
  dtc,
  pciutils,
  dmidecode,
  acpica-tools,
  libbsd,
}:

stdenv.mkDerivation rec {
  pname = "fwts";
  version = "24.09.00";

  src = fetchzip {
    url = "https://fwts.ubuntu.com/release/fwts-V${version}.tar.gz";
    hash = "sha256-ZJSlx8O38e7bJYTgZacayslr28TLHHJsISXq9Uzsnyc=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    pcre
    json_c
    flex
    bison
    dtc
    pciutils
    dmidecode
    acpica-tools
    libbsd
  ];

  postPatch = ''
    substituteInPlace src/lib/include/fwts_binpaths.h \
      --replace-fail "/usr/bin/lspci"      "${pciutils}/bin/lspci" \
      --replace-fail "/usr/sbin/dmidecode" "${dmidecode}/bin/dmidecode" \
      --replace-fail "/usr/bin/iasl"       "${acpica-tools}/bin/iasl"

    substituteInPlace src/lib/src/fwts_devicetree.c \
                      src/devicetree/dt_base/dt_base.c \
      --replace-fail "dtc -I" "${dtc}/bin/dtc -I"
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://wiki.ubuntu.com/FirmwareTestSuite";
    description = "Firmware Test Suite";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tadfisher ];
  };
}
