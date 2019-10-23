{ lib, mkDerivation, fetchFromGitLab
, cmake
, extra-cmake-modules
, fcitx
, pkgconfig
, qtbase
}:

mkDerivation rec {
  pname = "fcitx-qt5";
  version = "1.2.3";

  src = fetchFromGitLab {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "0860v3rxsh054wkkbawvyin5mk0flp4cwfcpmcpq147lvdm5lq2i";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig ];

  buildInputs = [ fcitx qtbase ];

  preConfigure = ''
    substituteInPlace platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QTPLUGINDIR}" $out/${qtbase.qtPluginPrefix}
    substituteInPlace quickphrase-editor/CMakeLists.txt \
      --replace \$"{FCITX4_ADDON_INSTALL_DIR}" $out/lib/fcitx
  '';

  meta = with lib; {
    homepage    = "https://gitlab.com/fcitx/fcitx-qt5";
    description = "Qt5 IM Module for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
