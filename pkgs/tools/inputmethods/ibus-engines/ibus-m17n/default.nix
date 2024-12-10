{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  ibus,
  gtk3,
  m17n_lib,
  m17n_db,
  gettext,
  python3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "ibus-m17n";
  version = "1.4.29";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus-m17n";
    rev = version;
    sha256 = "sha256-KHAdGTlRdTNpSuYbT6rocbT9rSNhxCdt4Z6QSLlbBsg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    wrapGAppsHook3
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

  meta = with lib; {
    isIbusEngine = true;
    description = "m17n engine for ibus";
    homepage = "https://github.com/ibus/ibus-m17n";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
