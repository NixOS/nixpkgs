{ stdenv
, lib
, fetchFromGitHub
, qmake
, wrapQtAppsHook
, libX11
, libXmu
, libXpm
, qtbase
, qtx11extras
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdocker";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "user-none";
    repo = "KDocker";
    rev = "${finalAttrs.version}";
    hash = "sha256-CTz2M9nv5Rf1amnSpLiIUZLH9Q3te6ZyFNUzSGHdYJc=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    libX11
    libXmu
    libXpm
    qtbase
    qtx11extras
  ];

  prePatch = ''
    for h in Xatom Xlib Xmu; do
      sed -i "s|#include <$h|#include <X11/$h|" src/xlibutil.h src/{kdocker,scanner,trayitem,trayitemmanager}.cpp
    done
    for t in target icons desktop appdata; do
      sed -i "s|$t.path = /usr|$t.path = $out|" kdocker.pro
    done
    sed -i "s|/etc/bash_completion.d|$out/share/bash-completion/completions|" kdocker.pro
  '';

  meta = with lib; {
    description = "Dock any application into the system tray";
    homepage = "https://github.com/user-none/KDocker";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hexclover ];
    platforms = platforms.linux;
    mainProgram = "kdocker";
  };
})
