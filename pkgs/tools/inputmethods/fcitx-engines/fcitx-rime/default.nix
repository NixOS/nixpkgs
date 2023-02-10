{ lib, stdenv, fetchurl, cmake, pkg-config, fcitx, librime, brise, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "fcitx-rime";
  version = "0.3.2";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx-rime/${pname}-${version}.tar.xz";
    sha256 = "0bd8snfa6jr8dhnm0s0z021iryh5pbaf7p15rhkgbigw2pssczpr";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx librime brise hicolor-icon-theme ];

  # cmake cannont automatically find our nonstandard brise install location
  cmakeFlags = [ "-DRIME_DATA_DIR=${brise}/share/rime-data" ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
       --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
       --replace ${fcitx} $out
  '';

  meta = with lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-rime";
    downloadPage  = "https://download.fcitx-im.org/fcitx-rime/";
    description   = "Rime support for Fcitx";
    license       = licenses.gpl2;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ sifmelcara ];
    # this package is deprecated, please use fcitx5 instead.
    # and it cannot be built with the new version of librime
    broken        = true;
  };
}
