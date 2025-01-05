{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.95";

  src = fetchFromGitHub {
    owner = "traviscross";
    repo = "mtr";
    rev = "v${version}";
    sha256 = "sha256-f5bL3IdXibIc1xXCuZHwcEV5vhypRE2mLsS3A8HW2QM=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/traviscross/mtr/pull/468
      url = "https://github.com/traviscross/mtr/commit/5908af4c19188cb17b62f23368b6ef462831a0cb.patch";
      hash = "sha256-rTydtU8+Wc4nGEKh1GOkhcpgME4hwsACy82gKPaIe64=";
    })
  ];

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

  buildInputs =
    [
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
      orivej
      raskin
      globin
    ];
    mainProgram = "mtr";
    platforms = platforms.unix;
  };
}
