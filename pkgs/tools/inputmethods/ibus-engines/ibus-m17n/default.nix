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
<<<<<<< HEAD
  version = "1.4.37";
=======
  version = "1.4.36";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus-m17n";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-cJ5kRz1qu7lmCBjJBS8fBE5YdQMZiISWoK1a2KHZ4cQ=";
=======
    sha256 = "sha256-K7grmYROFRwdmYWiWNRv8TnEUpOie1W8Glx9BP6Orzc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    isIbusEngine = true;
    description = "m17n engine for ibus";
    homepage = "https://github.com/ibus/ibus-m17n";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    isIbusEngine = true;
    description = "m17n engine for ibus";
    homepage = "https://github.com/ibus/ibus-m17n";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
