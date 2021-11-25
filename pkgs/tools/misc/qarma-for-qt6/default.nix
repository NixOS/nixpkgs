/*
qt6 build is failing
https://github.com/luebking/qarma/issues/41
*/

{ mkDerivation
, lib
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qmake2cmake
, cmake
, qt5compat
, pkg-config
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
}:

mkDerivation rec {
  pname = "qarma";
  version = "2021-10-05";

  src = fetchFromGitHub {
    name = "${pname}-${version}-source";
    owner = "luebking";
    repo = pname;
    rev = "605ea4213406718ba869dd146875195e57488786";
    sha256 = "KFoFywFeGqNmE1y49DrXJZ1jIK5jMOCOspkkFME+DR8=";
  };

  # FIXME only needed for qt6
  # set attributes for qt-6/hooks/qmake-hook.sh
  # TODO better. we do not want to set this for every libsForQt6.callPackage target
  inherit (qtbase) qtDocPrefix qtQmlPrefix qtPluginPrefix;

  patches = [
    ./qarma-qt6.patch
  ];

  patchPhase = ''
    sed -i.bak -E -e "s,(target\.path \+=) /usr/bin,\1 $out/bin," -e 's/x11extras/core-private/g' qarma.pro
    qmake2cmake qarma.pro
  '';

  buildInputs = [
    qtbase qtbase.dev qt5compat qt5compat.dev
    libglvnd libxkbcommon vulkan-headers
  ];

  nativeBuildInputs = [ qmake2cmake cmake wrapQtAppsHook pkg-config ];

  meta = with lib; {
    description = "CLI tool to create GUI dialogs with Qt";
    homepage = "https://github.com/luebking/qarma";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ milahu ];
  };
}
