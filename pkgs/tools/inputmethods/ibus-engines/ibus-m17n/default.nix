{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, ibus, m17n_lib, m17n_db, gettext, python3
}:

stdenv.mkDerivation rec {
  pname = "ibus-m17n";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner  = "ibus";
    repo   = "ibus-m17n";
    rev    = version;
    sha256 = "1xl7swqn46nhi43rka0zx666mpk667ykag3sz07x0zqrwi41frps";
  };

  buildInputs = [
    ibus m17n_lib m17n_db gettext
    python3
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig python3.pkgs.wrapPython ];

  postFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "m17n engine for ibus";
    homepage     = https://github.com/ibus/ibus-m17n;
    license      = licenses.gpl2;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ ericsagnes ];
  };
}
