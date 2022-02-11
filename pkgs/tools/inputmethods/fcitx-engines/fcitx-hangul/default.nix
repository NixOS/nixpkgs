{ lib, stdenv, fetchurl, cmake, fcitx, libhangul, gettext, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fcitx-hangul";
  version = "0.3.1";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-hangul/${pname}-${version}.tar.xz";
    sha256 = "0ds4071ljq620w7vnprm2jl8zqqkw7qsxvzbjapqak4jarczvmbd";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx libhangul gettext ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-hangul";
    downloadPage  = "http://download.fcitx-im.org/fcitx-hangul/";
    description   = "Fcitx Wrapper for hangul";
    license       = licenses.gpl2;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };
}
