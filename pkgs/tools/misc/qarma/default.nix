{ mkDerivation
, lib
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qmake
, qtx11extras ? null # qt5
, qt5compat ? null # qt6
}:

mkDerivation rec {
  pname = "qarma";
  version = "2022-01-16";

  src = fetchFromGitHub {
    owner = "luebking";
    repo = pname;
    rev = "6ee1a72635d0f7974a4e38c348a511f12b593043";
    sha256 = "P4Hc2Q3id2M9XGexic4hoPTngdV/hYcaizUuc06LuHU=";
  };

  buildInputs = [
    qtbase
  ] ++ lib.optionals (lib.versions.major qtbase.version == "5") [
    qtx11extras
  ] ++ lib.optionals (lib.versions.major qtbase.version == "6") [
    qt5compat
  ];

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  meta = with lib; {
    description = "CLI tool to create GUI dialogs with Qt";
    homepage = "https://github.com/luebking/qarma";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ milahu ];
  };
}
