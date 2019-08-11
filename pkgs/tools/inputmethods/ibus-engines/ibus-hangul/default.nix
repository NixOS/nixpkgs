{ stdenv, fetchurl, intltool, pkgconfig
, gtk3, ibus, libhangul, python3
}:

stdenv.mkDerivation rec {
  name = "ibus-hangul-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/choehwanjin/ibus-hangul/releases/download/${version}/${name}.tar.gz";
    sha256 = "0gha8dfdf54rx8fv3yfikbgdg6lqq6l883lhg7q68ybvkjx9bwbs";
  };

  buildInputs = [ gtk3 ibus libhangul python3 ];

  nativeBuildInputs = [ intltool pkgconfig python3.pkgs.wrapPython ];

  postFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Ibus Hangul engine";
    homepage     = https://github.com/choehwanjin/ibus-hangul;
    license      = licenses.gpl2;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ ericsagnes ];
  };
}
