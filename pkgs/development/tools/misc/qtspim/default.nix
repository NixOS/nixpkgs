{ lib, stdenv, fetchsvn, wrapQtAppsHook, qtbase, qttools, qmake, bison, flex, ... }:
stdenv.mkDerivation rec {
  pname = "qtspim";
  version = "9.1.22";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/spimsimulator/code/";
    rev = "r739";
    sha256 = "1kazfgrbmi4xq7nrkmnqw1280rhdyc1hmr82flrsa3g1b1rlmj1s";
  };

  postPatch = ''
    cd QtSpim

    # Patches from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=qtspim
    sed -i 's/zero_imm/is_zero_imm/g' parser_yacc.cpp
    sed -i 's/^int data_dir/bool data_dir/g' parser_yacc.cpp
    sed -i 's/^int text_dir/bool text_dir/g' parser_yacc.cpp
    sed -i 's/^int parse_error_occurred/bool parse_error_occurred/g' parser_yacc.cpp

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
    maintainers = with maintainers; [ angustrau ];
    platforms = platforms.linux;
  };
}
