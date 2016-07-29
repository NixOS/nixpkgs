{ stdenv, lib, fetchurl, cmake, fcitx, pkgconfig, qtbase, kde5 }:

stdenv.mkDerivation rec {
  name = "fcitx-qt5-${version}";
  version = "1.0.5";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-qt5/${name}.tar.xz";
    sha256 = "1pj1b04n8r4kl7jh1qdv0xshgzb3zrmizfa3g5h3yk589h191vwc";
  };

  # The following is to not have a dependency on kde5 so the plugin can be part of qt5LibsFun
  postUnpack = ''
    ${lib.concatMapStrings (f: ''
      ln -s ${kde5.extra-cmake-modules}/share/ECM/modules/${f} $sourceRoot/cmake/
    '')
    [ "ECMFindModuleHelpers.cmake" "ECMGenerateHeaders.cmake"
      "ECMPackageConfigHelpers.cmake" "ECMQueryQmake.cmake"
      "ECMSetupVersion.cmake" "ECMVersionHeader.h.in" ]}
  '';

  patches = [ ./fcitx-qt5-ecm.patch ];

  buildInputs = [ cmake fcitx pkgconfig qtbase ];

  preInstall = ''
    substituteInPlace platforminputcontext/cmake_install.cmake \
      --replace ${qtbase.out} $out
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/fcitx/fcitx-qt5";
    description = "Qt5 IM Module for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };

}
