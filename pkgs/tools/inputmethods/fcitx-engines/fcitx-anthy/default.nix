{ lib, stdenv, fetchurl, cmake, fcitx, anthy, gettext, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fcitx-anthy";
  version = "0.2.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-anthy/${pname}-${version}.tar.xz";
    sha256 = "01jx7wwq0mifqrzkswfglqhwkszbfcl4jinxgdgqx9kc6mb4k6zd";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx anthy gettext ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with lib; {
    isFcitxEngine = true;
    description   = "Fcitx Wrapper for anthy";
    license       = licenses.gpl2Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
