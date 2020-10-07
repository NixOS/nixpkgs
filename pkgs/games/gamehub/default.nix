{ stdenv ,fetchFromGitHub ,
  meson ,ninja ,vala ,pkg-config ,desktop-file-utils ,
  glib ,gtk3 ,libgee ,libsoup ,json-glib ,sqlite ,webkitgtk ,libmanette ,libXtst
}:
stdenv.mkDerivation rec {
  pname = "GameHub";
  version = "0.16.0-1";
  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = pname;
    rev = "${version}-master";
    sha256 = "sha256-QcpqGydNkmAPrPxp/52+D6MS1I7k+CKHxr3/tpCukP8=";
  };
  nativeBuildInputs = [
    meson ninja vala pkg-config desktop-file-utils

  ];
  propagatedBuildInputs = [
    glib gtk3 libgee libsoup
    json-glib sqlite webkitgtk libmanette libXtst
  ];
}