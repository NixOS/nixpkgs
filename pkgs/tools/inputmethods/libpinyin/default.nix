{ stdenv, fetchurl, glib, db, pkgconfig }:

stdenv.mkDerivation {
  name = "libpinyin-1.3.0";

  meta = with stdenv.lib; {
    description = "Library for intelligent sentence-based Chinese pinyin input method";
    homepace    = https://sourceforge.net/projects/libpinyin;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
  };

  buildInputs = [ glib db pkgconfig ];

  src = fetchurl {
    url = "mirror://sourceforge/project/libpinyin/libpinyin/libpinyin-1.3.0.tar.gz";
    sha256 = "e105c443b01cd67b9db2a5236435d5441cf514b997b891215fa65f16030cf1f2";
  };
}
