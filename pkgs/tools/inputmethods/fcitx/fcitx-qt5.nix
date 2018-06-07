{ stdenv, lib, fetchFcitxSource, cmake, fcitx, pkgconfig, qtbase, extra-cmake-modules }:

stdenv.mkDerivation rec {
  pname = "fcitx-qt5";
  version = "1.2.1";

  src = fetchFcitxSource {
    inherit pname version;
    sha256 = "0z8ax0dxk88byic41mfaiahjdv1k8ciwn97xfjkkgr4ijgscdr8c";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig ];

  buildInputs = [ fcitx qtbase ];

  preInstall = ''
    substituteInPlace platforminputcontext/cmake_install.cmake \
      --replace ${qtbase.out} $out
    substituteInPlace quickphrase-editor/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/fcitx/fcitx-qt5;
    description = "Qt5 IM Module for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };

}
