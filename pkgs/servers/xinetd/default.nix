{ lib
, stdenv
, fetchurl
, pkg-config
, libtirpc
}:

stdenv.mkDerivation rec {
  pname = "xinetd";
  version = "2.3.15.4";

  src = fetchurl {
    url = "https://github.com/openSUSE/xinetd/releases/download/${version}/xinetd-${version}.tar.xz";
    hash = "sha256-K6pYEBC8cDYavfo38SHpKuucXOZ/mnGRPOvWk1nMllQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libtirpc
  ];

  meta = {
    description = "Secure replacement for inetd";
    platforms = lib.platforms.linux;
    homepage = "https://github.com/openSUSE/xinetd";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
