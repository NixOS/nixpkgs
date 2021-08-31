{ stdenv, lib, fetchFromGitHub
, qmake, qtwebsockets, qtwebengine, wrapQtAppsHook, openconnect
}:

stdenv.mkDerivation rec {
  pname = "globalprotect-openconnect";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "c14a6ad1d2b62f8d297bc4cfbcb1dcea4d99112f";
    fetchSubmodules = true;
    sha256 = "1zkc3vk1j31n2zs5ammzv23dah7x163gfrzz222ynbkvsccrhzrk";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  buildInputs = [ openconnect qtwebsockets qtwebengine ];

  patchPhase = ''
    for f in GPClient/GPClient.pro \
      GPClient/com.yuezk.qt.gpclient.desktop \
      GPService/GPService.pro \
      GPService/dbus/com.yuezk.qt.GPService.service \
      GPService/systemd/gpservice.service; do
        substituteInPlace $f \
          --replace /usr $out \
          --replace /etc $out/lib;
    done;

    substituteInPlace GPService/gpservice.h \
      --replace /usr/local/bin/openconnect ${openconnect}/bin/openconnect;
  '';

  meta = with lib; {
    description = "GlobalProtect VPN client (GUI) for Linux based on OpenConnect that supports SAML auth mode";
    homepage = "https://github.com/yuezk/GlobalProtect-openconnect";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.jerith666 ];
    platforms = platforms.linux;
  };
}
