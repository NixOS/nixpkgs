{
  fetchFromGitHub,
  lib,
  stdenv,
  gtk2,
  pkg-config,
  qmake,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qt6gtk2";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-g5ZCwTnNEJJ57zEwNqMxrl0EWYJMt3PquZ2IsmxQYqk=";
  };

  buildInputs = [
    gtk2
    qtbase
  ];
  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/qt-6/plugins/{platformthemes,styles}
    cp -pr src/qt6gtk2-qtplugin/libqt6gtk2.so $out/lib/qt-6/plugins/platformthemes
    cp -pr src/qt6gtk2-style/libqt6gtk2-style.so $out/lib/qt-6/plugins/styles

    runHook postInstall
  '';

  meta = {
    description = "GTK+2.0 integration plugins for Qt6";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/trialuser02/qt6gtk2";
    maintainers = [ lib.maintainers.misterio77 ];
    platforms = lib.platforms.linux;
  };
})
