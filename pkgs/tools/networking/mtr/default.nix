{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libcap,
  ncurses,
  jansson,
  withGtk ? false,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "mtr${lib.optionalString withGtk "-gui"}";
  version = "0.96";

  src = fetchFromGitHub {
    owner = "traviscross";
    repo = "mtr";
    rev = "v${version}";
    sha256 = "sha256-Oit0jEm1g+jYCIoTak/mcdlF14GDkDOAWKmX2mYw30M=";
  };

  # we need this before autoreconfHook does its thing
  postPatch = ''
    echo ${version} > .tarball-version
  '';

  # and this after autoreconfHook has generated Makefile.in
  preConfigure = ''
    substituteInPlace Makefile.in \
      --replace ' install-exec-hook' ""
  '';

  configureFlags = lib.optional (!withGtk) "--without-gtk";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    jansson
  ]
  ++ lib.optional withGtk gtk3
  ++ lib.optional stdenv.hostPlatform.isLinux libcap;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Network diagnostics tool";
    homepage = "https://www.bitwizard.nl/mtr/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      koral
      raskin
      globin
      ryan4yin
    ];
    mainProgram = "mtr";
    platforms = platforms.unix;
  };
}
