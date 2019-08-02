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

  preInstall = ''
    substituteInPlace platforminputcontext/cmake_install.cmake \
      --replace ${qtbase.bin} $out
    substituteInPlace quickphrase-editor/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with lib; {
    homepage    = https://gitlab.com/fcitx/fcitx-qt5;
    description = "Qt5 IM Module for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
