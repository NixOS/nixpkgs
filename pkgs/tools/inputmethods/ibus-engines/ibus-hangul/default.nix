{ stdenv, fetchFromGitHub, intltool, pkgconfig
, gtk3, ibus, libhangul, librsvg, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-hangul";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "choehwanjin";
    repo = pname;
    rev = version;
    sha256 = "12l2spr32biqdbz01bzkamgq5gskbi6cd7ai343wqyy1ibjlkmp8";
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
