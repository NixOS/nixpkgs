{ stdenv ,fetchFromGitHub ,
  meson ,ninja ,vala ,pkg-config ,desktop-file-utils ,
  glib ,gtk3 ,libgee ,libsoup ,json-glib ,sqlite ,webkitgtk ,libmanette ,libXtst ,wrapGAppsHook
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
    meson ninja vala pkg-config
    desktop-file-utils wrapGAppsHook

  ];
  propagatedBuildInputs = [
    glib gtk3 libgee libsoup
    json-glib sqlite webkitgtk libmanette libXtst
  ];
  meta = with stdenv.lib;{
    description = "All your games in one place";
    homepage = "https://tkashkin.tk/projects/gamehub/";
    mantainers = with mantainers;[ pasqui23 ];
    license = with licenses;[ gpl3Only ];
    platforms = with platforms;[ linux ];
  };
}
