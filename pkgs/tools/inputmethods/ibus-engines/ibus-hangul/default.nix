{ stdenv, fetchurl, intltool, pkgconfig
, gtk3, ibus, libhangul, librsvg, python3, pygobject3
}:

stdenv.mkDerivation rec {
  name = "ibus-hangul-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/choehwanjin/ibus-hangul/releases/download/${version}/${name}.tar.gz";
    sha256 = "120p9w7za6hi521hz8q235fkl4i3p1qqr8nqm4a3kxr0pcq40bd2";
  };

  buildInputs = [ gtk3 ibus libhangul python3 pygobject3 ];

  nativeBuildInputs = [ intltool pkgconfig ];

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Ibus Hangul engine";
    homepage     = https://github.com/choehwanjin/ibus-hangul;
    license      = licenses.gpl2;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ ericsagnes ];
  };
}
