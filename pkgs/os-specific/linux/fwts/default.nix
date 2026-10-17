{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  glib,
  json_c,
  flex,
  bison,
  dtc,
  pciutils,
  dmidecode,
  acpica-tools,
  libbsd,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fwts";
  version = "26.09.00";

  src = fetchFromGitHub {
    owner = "fwts";
    repo = "fwts";
    rev = "V${finalAttrs.version}";
    hash = "sha256-TD4MygsyS0GJcsl1+nrLaSKSqMGm8YfbT83INfUdGYM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    json_c
    flex
    bison
    dtc
    pciutils
    dmidecode
    acpica-tools
    libbsd
    zlib
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
})
