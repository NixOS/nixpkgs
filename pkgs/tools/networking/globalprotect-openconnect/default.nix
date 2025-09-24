{
  stdenv,
  lib,
  fetchurl,
  cmake,
  qtwebsockets,
  qtwebengine,
  qtkeychain,
  wrapQtAppsHook,
  openconnect,
}:

stdenv.mkDerivation rec {
  pname = "globalprotect-openconnect";
  version = "1.4.9";

  src = fetchurl {
    url = "https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${version}/globalprotect-openconnect-${version}.tar.gz";
    hash = "sha256-vhvVKESLbqHx3XumxbIWOXIreDkW3yONDMXMHxhjsvk=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    openconnect
    qtwebsockets
    qtwebengine
    qtkeychain
  ];

  patchPhase = ''
    substituteInPlace GPService/gpservice.h \
      --replace /usr/local/bin/openconnect ${openconnect}/bin/openconnect;
    substituteInPlace GPService/CMakeLists.txt \
      --replace /etc/gpservice $out/etc/gpservice;
  '';

  meta = with lib; {
    description = "GlobalProtect VPN client (GUI) for Linux based on OpenConnect that supports SAML auth mode";
    homepage = "https://github.com/yuezk/GlobalProtect-openconnect";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.jerith666 ];
    platforms = platforms.linux;
  };
}
