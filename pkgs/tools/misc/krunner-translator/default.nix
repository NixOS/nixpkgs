{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  krunner,
  kconfigwidgets,
  ktextwidgets,
  kservice,
  ki18n,
  translate-shell,
  qtbase,
  qtdeclarative,
  qtlocation,
}:

stdenv.mkDerivation rec {
  pname = "krunner-translator";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "naraesk";
    repo = pname;
    rev = "v${version}";
    sha256 = "8MusGvNhTxa8Sm8WiSwRaVIfZOeXmgcO4T6H9LqFGLs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  dontWrapQtApps = true;

  buildInputs = [
    krunner
    kconfigwidgets
    ktextwidgets
    kservice
    ki18n
    qtbase
    qtdeclarative
    qtlocation
  ];

  postPatch = ''
    substituteInPlace src/translateShellProcess.cpp --replace "start(\"trans\", arguments);" "start(\"${translate-shell}/bin/trans\", arguments);"
  '';

  meta = with lib; {
    description = "Plugin for KRunner which integrates a translator, supports Google Translate, Bing Translator, youdao and Baidu Fanyi";
    homepage = "https://github.com/naraesk/krunner-translator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pongo1231 ];
    platforms = platforms.unix;
  };
}
