{ stdenv, fetchFromGitHub, autoreconfHook
, intltool, pkgconfig, sqlite, libpinyin, db
, ibus, glib, gtk3, python3
}:

stdenv.mkDerivation rec {
  name = "ibus-libpinyin-${version}";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner  = "libpinyin";
    repo   = "ibus-libpinyin";
    rev    = version;
    sha256 = "067w926gcf0kwwn71yshhjmyzkad0qsdm1dsi2xwz1j633qd4xlb";
  };

  buildInputs = [ ibus glib sqlite libpinyin python3 gtk3 db ];
  nativeBuildInputs = [ autoreconfHook intltool pkgconfig python3.pkgs.wrapPython ];

  postAutoreconf = ''
    intltoolize
  '';

  postFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "IBus interface to the libpinyin input method";
    license      = licenses.gpl2;
    maintainers  = with maintainers; [ ericsagnes ];
    platforms    = platforms.linux;
  };
}
