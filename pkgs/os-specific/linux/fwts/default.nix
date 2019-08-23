{ stdenv, fetchzip, autoreconfHook, pkgconfig, glib, libtool, pcre
, json_c, flex, bison, dtc, pciutils, dmidecode, iasl, libbsd }:

stdenv.mkDerivation rec {
  name = "fwts-${version}";
  version = "19.07.00";

  src = fetchzip {
    url = "http://fwts.ubuntu.com/release/fwts-V${version}.tar.gz";
    sha256 = "04h99ri3nzhxr2js2a04bcj6zm17zlybqzv528j6hr6v0pv5wn4p";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool ];
  buildInputs = [ glib pcre json_c flex bison dtc pciutils dmidecode iasl libbsd ];

  postPatch = ''
    substituteInPlace src/lib/include/fwts_binpaths.h --replace "/usr/bin/lspci"      "${pciutils}/bin/lspci"
    substituteInPlace src/lib/include/fwts_binpaths.h --replace "/usr/sbin/dmidecode" "${dmidecode}/bin/dmidecode"
    substituteInPlace src/lib/include/fwts_binpaths.h --replace "/usr/bin/iasl"       "${iasl}/bin/iasl"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://wiki.ubuntu.com/FirmwareTestSuite";
    description = "Firmware Test Suite";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ tadfisher ];
  };
}
