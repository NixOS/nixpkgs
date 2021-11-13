{ lib
, stdenv
, fetchurl
, libmnl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "ethtool";
  version = "5.14";

  src = fetchurl {
    url = "mirror://kernel/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-uxPbkZFcrNekkrZbZd8Hpn5Ll03b6vdiBbGUWiPSdoY=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libmnl
  ];

  meta = with lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = "https://www.kernel.org/pub/software/network/ethtool/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
