{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, ibus
, gtk3
, m17n_lib
, m17n_db
, gettext
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ibus-m17n";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus-m17n";
    rev = version;
    sha256 = "0lb2vcnkzy64474j7306ydyw1ali0qbx07sxfms2fqv1nmh161i2";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    ibus
    gtk3
    m17n_lib
    m17n_db
    (python3.withPackages (ps: [
      ps.pygobject3
      (ps.toPythonModule ibus)
    ]))
  ];

  configureFlags = [
    "--with-gtk=3.0"
  ];

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "m17n engine for ibus";
    homepage = "https://github.com/ibus/ibus-m17n";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
