{ stdenv, fetchurl, cmake, pkgconfig, fcitx, librime, brise, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "fcitx-rime-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx-rime/${name}.tar.xz";
    sha256 = "0bd8snfa6jr8dhnm0s0z021iryh5pbaf7p15rhkgbigw2pssczpr";
  };

  buildInputs = [ cmake pkgconfig fcitx librime brise hicolor-icon-theme ];

  # cmake cannont automatically find our nonstandard brise install location
  cmakeFlags = [ "-DRIME_DATA_DIR=${brise}/share/rime-data" ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
       --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
       --replace ${fcitx} $out
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    homepage      = https://github.com/fcitx/fcitx-rime;
    downloadPage  = https://download.fcitx-im.org/fcitx-rime/;
    description   = "Rime support for Fcitx";
    license       = licenses.gpl2;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ sifmelcara ];
  };
}
