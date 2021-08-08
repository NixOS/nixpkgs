{ lib, stdenv, fetchzip, autoreconfHook, pkg-config, glib, pcre
, json_c, flex, bison, dtc, pciutils, dmidecode, iasl, libbsd }:

stdenv.mkDerivation rec {
  pname = "fwts";
  version = "20.11.00";

  src = fetchzip {
    url = "https://fwts.ubuntu.com/release/${pname}-V${version}.tar.gz";
    sha256 = "0s8iz6c9qhyndcsjscs3qail2mzfywpbiys1x232igm5kl089vvr";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ glib pcre json_c flex bison dtc pciutils dmidecode iasl libbsd ];

  postPatch = ''
    substituteInPlace src/lib/include/fwts_binpaths.h \
      --replace "/usr/bin/lspci"      "${pciutils}/bin/lspci" \
      --replace "/usr/sbin/dmidecode" "${dmidecode}/bin/dmidecode" \
      --replace "/usr/bin/iasl"       "${iasl}/bin/iasl"
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
