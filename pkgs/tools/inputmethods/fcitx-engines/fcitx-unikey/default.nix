{ lib, stdenv, fetchurl, cmake, fcitx, gettext, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fcitx-unikey";
  version = "0.2.5";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-unikey/${pname}-${version}.tar.xz";
    sha256 = "063vc29v7ycaai98v3z4q319sv9sm91my17pmhblw1vifxnw02wf";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx gettext ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-unikey";
    downloadPage  = "http://download.fcitx-im.org/fcitx-table-other/";
    description   = "Fcitx wrapper for unikey";
    license       = licenses.gpl3Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
