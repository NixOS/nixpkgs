{ stdenv, fetchurl, cmake, pkgconfig, fcitx, gettext, libpinyin, glib, pcre, dbus, qt4 }:

stdenv.mkDerivation rec {
  name = "fcitx-libpinyin-${version}";
  version = "0.3.91";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-libpinyin/${name}.tar.xz";
    sha256 = "19h0p1s8bkw24v7x6v19fg7dqpz2kkjlvvrqhypi5bkkvfswf7xn";
  };

  buildInputs = [ cmake pkgconfig fcitx gettext libpinyin glib pcre dbus qt4 ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace po/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace dictmanager/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  preBuild = let
    store_path = fetchurl {
      url = https://download.fcitx-im.org/data/model.text.20130308.tar.gz;
      sha256 = "0s8sazix29z1ilxmkw2f0bv6i349awd89ibylf9ixy615s1vb5a5";
    };
  in
    ''
      cp -rv ${store_path} $NIX_BUILD_TOP/$name/data/model.text.20130308.tar.gz
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
