{ stdenv, lib, fetchFromGitHub
, cmake, qtwebsockets, qtwebengine, wrapQtAppsHook, openconnect
}:

stdenv.mkDerivation rec {
  pname = "globalprotect-openconnect";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-PQAlGeHVayImKalCNv2SwPcxD0ts4BVSqeo1hKYmnMA=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ openconnect qtwebsockets qtwebengine ];

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
