{
  lib,
  stdenv,
  fetchFromGitLab,
  qmake,
  qtbase,
  qtdeclarative,
  qtwebengine,
  wrapQtAppsHook,
  signond,
  pkg-config,
  libnotify,
  accounts-qt,
}:

stdenv.mkDerivation {
  pname = "signon-ui";
  version = "0.17-unstable-2023-10-16";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "signon-ui";
    rev = "eef943f0edf3beee8ecb85d4a9dae3656002fc24";
    hash = "sha256-L37nypdrfg3ZGZE4uGtFoJlzNbFgTVgA36zCgzvzk6E=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtwebengine
    signond
    libnotify
    accounts-qt
  ];

  qmakeFlags = [ "SUBDIRS=src" ];

  meta = {
    homepage = "https://gitlab.com/accounts-sso/signon-ui";
    description = "UI component responsible for handling the user interactions which can happen during the login process of an online account";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ marie ];
    platforms = lib.platforms.linux;
  };
}
