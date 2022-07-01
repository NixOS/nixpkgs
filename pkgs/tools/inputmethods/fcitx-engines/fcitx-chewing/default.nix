{ lib, stdenv, fetchurl, cmake, fcitx, gettext, libchewing, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fcitx-chewing";
  version = "0.2.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-chewing/${pname}-${version}.tar.xz";
    sha256 = "1w5smp5zvjx681cp1znjypyr9sw5x6v0wnsk8a7ncwxi9q9wf4xk";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx gettext libchewing ];

  preInstall = ''
   substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
   substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-chewing";
    downloadPage  = "http://download.fcitx-im.org/fcitx-chewing/";
    description   = "Fcitx engine for chewing";
    license       = licenses.gpl2;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
