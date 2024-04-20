{ lib
, stdenv
, fetchurl
, pkg-config
, libtirpc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xinetd";
  version = "2.3.15.4";

  src = fetchurl {
    url = "https://github.com/openSUSE/xinetd/releases/download/${finalAttrs.version}/xinetd-${finalAttrs.version}.tar.xz";
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
    license = lib.licenses.xinetd;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
