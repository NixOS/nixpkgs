{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config
, libcap, ncurses
, withGtk ? false, gtk3 ? null }:

assert withGtk -> gtk3 != null;

stdenv.mkDerivation rec {
  pname = "mtr${lib.optionalString withGtk "-gui"}";
  version = "0.94";

  src = fetchFromGitHub {
    owner  = "traviscross";
    repo   = "mtr";
    rev    = "v${version}";
    sha256 = "0wnz87cr2lcl74bj8qxq9xgai40az3pk9k0z893scyc8svd61xz6";
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

  configureFlags = stdenv.lib.optional (!withGtk) "--without-gtk";

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ncurses ]
    ++ stdenv.lib.optional withGtk gtk3
    ++ stdenv.lib.optional stdenv.isLinux libcap;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A network diagnostics tool";
    homepage    = "https://www.bitwizard.nl/mtr/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ koral orivej raskin globin ];
    platforms   = platforms.unix;
  };
}
