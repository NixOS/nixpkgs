# TODO(milahu) cleanup

{ mkDerivation
, lib
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qmake
, qt5compat
, pkg-config
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
}:

/*
FIXME include paths should be $dev not $out
build flags: -j4 -l4 SHELL=/nix/store/wadmyilr414n7bimxysbny876i2vlm5r-bash-5.1-p8/bin/bash
g++ -c -pipe -O2 -std=gnu++1z -Wall -Wextra -D_REENTRANT -fPIC -DWS_X11 -DQT_NO_DEBUG
 -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_DBUS_LIB -DQT_CORE_LIB -I.
 -I/nix/store/4frx7964wbnsq76ybsfphqr1b9vr71kn-qtbase-6.2.1/include
 -I/nix/store/4frx7964wbnsq76ybsfphqr1b9vr71kn-qtbase-6.2.1/include/QtWidgets

user@laptop1:/nix/store/4gllgq492npdmvwc6gb5kvi119libj21-qtbase-6.2.1-dev/mkspecs
./modules/qt_lib_widgets.pri:6:QT.widgets.includes = $$QT_MODULE_INCLUDE_BASE $$QT_MODULE_INCLUDE_BASE/QtWidgets

/nix/store/4gllgq492npdmvwc6gb5kvi119libj21-qtbase-6.2.1-dev/mkspecs/features/qt_config.prf
         QT_MODULE_INCLUDE_BASE = $$[QT_INSTALL_HEADERS]
         QT_MODULE_LIB_BASE = $$[QT_INSTALL_LIBS]
         QT_MODULE_HOST_LIB_BASE = $$[QT_HOST_LIBS]
         QT_MODULE_HOST_LIBEXEC_BASE = $$[QT_HOST_LIBEXECS]
         QT_MODULE_BIN_BASE = $$[QT_INSTALL_BINS]


*/

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

    echo "debug: qtbase.out = ${qtbase.out}"
    echo "debug: qtbase.dev = ${qtbase.dev}"
    echo "debug: qtbase.bin = ${qtbase.bin}"

    sed -i.bak -E -e "s,(target\.path \+=) /usr/bin,\1 $out/bin," -e 's/x11extras/core-private/g' qarma.pro

    # qtbase-6.2.1-dev/mkspecs/linux-g++
    export QMAKEPATH="${qtbase.out}:${qtbase.dev}:$QMAKEPATH"

    #export LD_LIBRARY_PATH="${qtbase.out}/lib:$LD_LIBRARY_PATH"

    # /nix/store/i9vknhf60qi16k64h5zspmq6ysiijym4-qtbase-6.2.1-dev/mkspecs/common/linux.conf
    export QMAKE_LIBDIR="${qtbase.out}/lib:$QMAKE_LIBDIR"
    export QMAKE_INCDIR="${qtbase.dev}/include:$QMAKE_INCDIR"

    # workaround for: fatal error: QApplication: No such file or directory
    # no effect: export QMAKE_INCDIR="${qtbase.dev}/include/QtWidgets:$QMAKE_INCDIR"
    # probably we need to patch qmake files, so qmake can find headers

    # workaround for bug in qtbase.nix
    export QMAKE_INCDIR_OPENGL_ES2="${libglvnd.dev}/include"
    export QMAKE_LIBDIR_OPENGL_ES2="${libglvnd.out}/lib"

    # workaround for bug in qtbase-6.2.1-dev/mkspecs/features/qt_config.prf
    # no effect: export QMAKE_QT_CONFIG="${qtbase.dev}/mkspecs/qconfig.pri"

    # no effect: export QT_INSTALL_HEADERS="${qtbase.dev}/include"

    echo "debug: LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
  '';

  # https://doc.qt.io/qt-5/qmake-environment-reference.html
  preConfigure = ''
    export HOME=/tmp

    # no effect
    echo qmake -set QT_INSTALL_HEADERS "${qtbase.dev}/include"
    qmake -set QT_INSTALL_HEADERS "${qtbase.dev}/include"

    echo 'qmake -query QT_INSTALL_HEADERS'
    qmake -query QT_INSTALL_HEADERS

    echo 'qmake -query | grep QT_INSTALL_HEADERS'
    qmake -query | grep QT_INSTALL_HEADERS

    find /tmp/.config
    cat /tmp/.config/QtProject/QMake.conf

    echo QT_INSTALL_HEADERS
    echo "expected = ${qtbase.dev}/include"
    echo "actual   = $(qmake -query QT_INSTALL_HEADERS)"

    exit 1
  '';

/*
FIXME
DEBUG 1: /nix/store/i9vknhf60qi16k64h5zspmq6ysiijym4-qtbase-6.2.1-dev/mkspecs/features/qt_config.prf:3:
  QMAKE_QT_CONFIG := /nix/store/4fdbrdh8h5h5ag6bl20pnv6lb7xqgd28-qtbase-6.2.1/mkspecs/qconfig.pri
/nix/store/4fdbrdh8h5h5ag6bl20pnv6lb7xqgd28-qtbase-6.2.1/mkspecs/qconfig.pri       no such file
/nix/store/i9vknhf60qi16k64h5zspmq6ysiijym4-qtbase-6.2.1-dev/mkspecs/qconfig.pri   ok

/nix/store/i9vknhf60qi16k64h5zspmq6ysiijym4-qtbase-6.2.1-dev/mkspecs/features/qt_config.prf
QMAKE_QT_CONFIG = $$[QT_HOST_DATA/get]/mkspecs/qconfig.pri

*/
  qmakeFlags = [
    #"-makefile"
    #"-d" # debug. verbose!
    "-Wall" # warnings
    "QT_INSTALL_HEADERS=${qtbase.dev}/include"
  ];

  buildInputs = [ qtbase qt5compat ];
  nativeBuildInputs = [ qmake wrapQtAppsHook pkg-config ];

  meta = with lib; {
    description = "CLI tool to create GUI dialogs with Qt";
    homepage = "https://github.com/luebking/qarma";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ milahu ];
  };
}
