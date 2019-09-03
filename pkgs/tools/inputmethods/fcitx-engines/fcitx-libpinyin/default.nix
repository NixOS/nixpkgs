{ stdenv, fetchurl, cmake, pkgconfig, fcitx, gettext, libpinyin, glib, pcre, dbus, qtwebengine, qtbase, fcitx-qt5 }:

stdenv.mkDerivation rec {
  pname = "fcitx-libpinyin";
  version = "0.5.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-libpinyin/${pname}-${version}.tar.xz";
    sha256 = "196c229ckib3xvafkk4n3n3jk9rpksfcjsbbwka6a9k2f34qrjj6";
  };

  nativeBuildInputs = [ pkgconfig  ];
  buildInputs = [ fcitx-qt5 qtbase qtwebengine.dev cmake fcitx gettext libpinyin glib pcre dbus ];

  # With a typical installation via NixOS option i18n.inputMethod.fcitx.engines,
  # the FCITXDIR environment variable is set to $out of fcitx-with-plugins,
  # which leads to an incorrect path for pinyin data.
  #
  # It is impossible or difficult to fix this issue without patching. We want
  # FCITXDIR to point into libpinyin, which is currently not symlinked within
  # fcitx-with-plugins (only fcitx-libpinyin is symlinked). Also, FCITXDIR
  # doesn't accept multiple directories.
  patches = [ ./datapath.patch ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace dictmanager/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  preBuild = let
    ZHUYIN_DATA_FILE_NAME = "model.text.20161206.tar.gz";
    store_path = fetchurl {
      url = "https://download.fcitx-im.org/data/${ZHUYIN_DATA_FILE_NAME}";
      sha256 = "017p11si1b7bkwx36xaybq5a9icq1pd7x1jbymqw92akfgjj8w2w";
    };
  in
    ''
      cp -rv ${store_path} $NIX_BUILD_TOP/$name/data/${ZHUYIN_DATA_FILE_NAME}
    '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    description  = "Fcitx Wrapper for libpinyin, Library to deal with pinyin";
    homepage     = https://github.com/fcitx/fcitx-libpinyin;
    license      = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms    = platforms.linux;
  };
}
