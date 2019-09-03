{ stdenv, fetchFromGitHub, cmake, pkgconfig, fcitx, libskk, skk-dicts }:

stdenv.mkDerivation rec {
  pname = "fcitx-skk";
  version = "0.1.4";
  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx-skk";
    rev = "f66d0f56a40ff833edbfa68a4be4eaa2e93d0e3d";
    sha256 = "1yl2syqrk212h26vzzkwl19fyp71inqmsli9411h4n2hbcp6m916";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ fcitx libskk skk-dicts ];

  cmakeFlags = [ "-DSKK_DEFAULT_PATH=${skk-dicts}/share/SKK-JISYO.combined"
                 "-DENABLE_QT=FALSE"
               ];
  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace po/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    description   = "A SKK style input method engine for fcitx";
    longDescription = ''
      Fcitx-skk is an input method engine for fcitx. It is based on libskk and thus
      provides basic features of SKK Japanese input method such as kana-to-kanji conversion,
      new word registration, completion, numeric conversion, abbrev mode, kuten input,
      hankaku-katakana input, and re-conversion.
    '';
    license       = licenses.gpl3Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ yuriaisaka ];
  };

}
