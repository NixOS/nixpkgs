{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, ibus, m17n_lib, m17n_db, gettext, python3
}:

stdenv.mkDerivation rec {
  name = "ibus-m17n-${version}";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner  = "ibus";
    repo   = "ibus-m17n";
    rev    = version;
    sha256 = "1n0bvgc4jyksgvzrw5zs2pxcpxcn3gcc0j2kasbznm34fpv3frsr";
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
