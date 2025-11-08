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

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.16")
  ];

  buildInputs = [
    openconnect
    qtwebsockets
    qtwebengine
    qtkeychain
  ];

  patchPhase = ''
    substituteInPlace GPService/gpservice.h \
      --replace-fail /usr/local/bin/openconnect ${openconnect}/bin/openconnect;
    substituteInPlace GPService/CMakeLists.txt \
      --replace-fail /etc/gpservice $out/etc/gpservice;
    # Force minimum CMake version to 3.16 to avoid policy warnings
    find . -name "CMakeLists.txt" -exec sed -i 's/cmake_minimum_required(VERSION [^)]*)/cmake_minimum_required(VERSION 3.16)/g' {} \;
  '';

  meta = with lib; {
    description = "GlobalProtect VPN client (GUI) for Linux based on OpenConnect that supports SAML auth mode";
    homepage = "https://github.com/yuezk/GlobalProtect-openconnect";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.jerith666 ];
    platforms = platforms.linux;
  };
}
