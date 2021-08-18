{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  pname = "ethtool";
  version = "5.13";

  src = fetchurl {
    url = "mirror://kernel/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1wwcwiav0fbl75axmx8wms4xfdp1ji5c7j49k4yl8bngqra74fp6";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = with lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = "https://www.kernel.org/pub/software/network/ethtool/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
