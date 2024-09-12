{
  lib,
  stdenv,
  fetchFromGitLab,
  qtbase,
  signond,
  wrapQtAppsHook,
  pkg-config,
  qmake,
}:

stdenv.mkDerivation {
  pname = "signon-plugin-oauth2";
  version = "0.25-unstable-2023-11-24";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "signon-plugin-oauth2";
    # See MR: https://gitlab.com/accounts-sso/signon-plugin-oauth2/-/merge_requests/28
    rev = "fab698862466994a8fdc9aa335c87b4f05430ce6";
    hash = "sha256-KCBLaqQdBkb6KfVKMmFSLOiXx3rUiEmK41Bc3mi86Ls=";
  };

  postPatch = ''
    echo 'INSTALLS =' >>tests/tests.pro
    echo 'INSTALLS =' >>example/example.pro
  '';

  buildInputs = [
    qtbase
    signond
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    qmake
  ];

  qmakeFlags = [
    "SIGNON_PLUGINS_DIR=${placeholder "out"}/lib/signond"
  ];

  meta = {
    homepage = "https://gitlab.com/accounts-sso/signon-plugin-oauth2";
    description = "Signond plugin which handles OAuth authentication";
    maintainers = with lib.maintainers; [ marie ];
    platforms = lib.platforms.linux;
  };
}
