{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, libcap
, ncurses
, jansson
, withGtk ? false
, gtk3
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

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ncurses jansson ]
    ++ lib.optional withGtk gtk3
    ++ lib.optional stdenv.isLinux libcap;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A network diagnostics tool";
    homepage = "https://www.bitwizard.nl/mtr/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ koral orivej raskin globin ];
    platforms = platforms.unix;
  };
}
