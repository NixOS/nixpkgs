{ stdenv, lib, fetchFromGitHub
, cmake, qtwebsockets, qtwebengine, wrapQtAppsHook, openconnect
}:

stdenv.mkDerivation rec {
  pname = "globalprotect-openconnect";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-9wRe7pJiosk2b0FKhHKpG6P2QPuBo8bVi6rnUMIkG6I=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ openconnect qtwebsockets qtwebengine ];

  patchPhase = ''
    substituteInPlace GPService/gpservice.h \
      --replace /usr/local/bin/openconnect ${openconnect}/bin/openconnect;
    substituteInPlace GPClient/settingsdialog.ui \
      --replace /etc/gpservice/gp.conf $out/etc/gpservice/gp.conf;
    substituteInPlace GPService/gpservice.cpp \
      --replace /etc/gpservice/gp.conf $out/etc/gpservice/gp.conf;
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
