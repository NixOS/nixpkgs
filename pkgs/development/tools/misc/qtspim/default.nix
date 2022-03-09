{ lib, stdenv, fetchsvn, wrapQtAppsHook, qtbase, qttools, qmake, bison, flex, ... }:
stdenv.mkDerivation rec {
  pname = "qtspim";
  version = "9.1.23";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/spimsimulator/code/";
    rev = "r749";
    sha256 = "0iazl7mlcilrdbw8gb98v868a8ldw2lmkn1xs8hnfvr93l6aj0rp";
  };

  postPatch = ''
    cd QtSpim

    substituteInPlace QtSpim.pro --replace /usr/lib/qtspim/lib $out/lib
    substituteInPlace menu.cpp \
      --replace /usr/lib/qtspim/bin/assistant ${qttools.dev}/bin/assistant \
      --replace /usr/lib/qtspim/help/qtspim.qhc $out/share/help/qtspim.qhc
    substituteInPlace ../Setup/qtspim_debian_deployment/qtspim.desktop \
      --replace /usr/bin/qtspim qtspim \
      --replace /usr/lib/qtspim/qtspim.png qtspim
  '';

  nativeBuildInputs = [ wrapQtAppsHook qttools qmake bison flex ];
  buildInputs = [ qtbase ];
  QT_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}";

  qmakeFlags = [
    "QtSpim.pro"
    "-spec"
    "linux-g++"
    "CONFIG+=release"
  ];

  installPhase = ''
    runHook preInstall

    install -D QtSpim $out/bin/qtspim
    install -D ../Setup/qtspim_debian_deployment/copyright $out/share/licenses/qtspim/copyright
    install -D ../Setup/qtspim_debian_deployment/qtspim.desktop $out/share/applications/qtspim.desktop
    install -D ../Setup/NewIcon48x48.png $out/share/icons/hicolor/48x48/apps/qtspim.png
    install -D ../Setup/NewIcon256x256.png $out/share/icons/hicolor/256x256/apps/qtspim.png
    cp -r help $out/share/help

    runHook postInstall
  '';

  meta = with lib; {
    description = "New user interface for spim, a MIPS simulator";
    homepage = "http://spimsimulator.sourceforge.net/";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.linux;
  };
}
