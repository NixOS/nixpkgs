{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libcap, ncurses
, withGtk ? false, gtk2 ? null }:

assert withGtk -> gtk2 != null;

stdenv.mkDerivation rec {
  pname = "mtr";
  version = "0.93";

  src = fetchFromGitHub {
    owner  = "traviscross";
    repo   = "mtr";
    rev    = "v${version}";
    sha256 = "0n0zr9k61w7a9psnzgp7xnc7ll1ic2xzcvqsbbbyndg3v9rff6bw";
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

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ncurses ]
    ++ stdenv.lib.optional withGtk gtk2
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
