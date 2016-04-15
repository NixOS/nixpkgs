{ stdenv, fetchurl, intltool, pkgconfig, sqlite, libpinyin, db
, ibus, glib, gtk3, python3, pygobject3
}:

stdenv.mkDerivation rec {
  name = "ibus-libpinyin-${version}";
  version = "1.7.4";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "IBus interface to the libpinyin input method";
    homepage     = https://github.com/libpinyin/ibus-libpinyin;
    license      = licenses.gpl2;
    platforms    = platforms.linux;
  };

  #configureFlags = "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t";

  buildInputs = [
  ibus glib sqlite libpinyin python3 gtk3 db
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  src = fetchurl {
    url = "mirror://sourceforge/project/libpinyin/ibus-libpinyin/ibus-libpinyin-${version}.tar.gz";
    sha256 = "c2085992f76ca669ebe4b7e7c0170433bbfb61f764f8336b3b17490b9fb1c334";
  };
}
