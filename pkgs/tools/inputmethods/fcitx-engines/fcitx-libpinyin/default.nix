{ stdenv, fetchurl, cmake, pkgconfig, fcitx, gettext, libpinyin, glib, qt4, pcre, curl, cacert }:

stdenv.mkDerivation rec {
  name = "fcitx-libpinyin-${version}";
  version = "0.3.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-libpinyin/${name}.tar.xz";
    sha256 = "08r8kw6gwy5lmx9z4rjsnqzx9qzaylgzvy6s0ppk7dvh0b612nx8";
  };

  buildInputs = [ cmake pkgconfig fcitx gettext glib qt4 pcre libpinyin curl ];

  cmakeFlags = ["-DCMAKE_VERBOSE_MAKEFILE=ON"];
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace po/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace dictmanager/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    description  = "Libpinyin Wrapper for Fcitx";
    homepage     = https://github.com/fcitx/fcitx-libpinyin;
    license      = licenses.gpl3Plus;
    platforms    = platforms.linux;
  };
}
