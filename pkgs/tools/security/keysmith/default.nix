{ lib
, mkDerivation
, makeWrapper
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, qtquickcontrols2
, qtdeclarative
, qtgraphicaleffects
, kirigami2
, oathToolkit
}:
mkDerivation rec {

  pname = "keysmith";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "keysmith";
    rev = "v${version}";
    sha256 = "15fzf0bvarivm32zqa5w71mscpxdac64ykiawc5hx6kplz93bsgx";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeWrapper ];

  buildInputs = [ oathToolkit kirigami2 qtquickcontrols2 qtbase ];

  postInstall = ''
    mv $out/bin/org.kde.keysmith $out/bin/.org.kde.keysmith-wrapped
    makeWrapper $out/bin/.org.kde.keysmith-wrapped $out/bin/org.kde.keysmith \
      --set QML2_IMPORT_PATH "${lib.getLib kirigami2}/lib/qt-5.12.7/qml:${lib.getBin qtquickcontrols2}/lib/qt-5.12.7/qml:${lib.getBin qtdeclarative}/lib/qt-5.12.7/qml:${qtgraphicaleffects}/lib/qt-5.12.7/qml" \
      --set QT_PLUGIN_PATH "${lib.getBin qtbase}/lib/qt-5.12.7/plugins"
    ln -s $out/bin/org.kde.keysmith $out/bin/keysmith
  '';

  meta = with lib; {
    description = "OTP client for Plasma Mobile and Desktop";
    license = licenses.gpl3;
    homepage = "https://github.com/KDE/keysmith";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
