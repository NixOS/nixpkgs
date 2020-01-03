{ fetchFromGitHub, ncurses, stdenv,
  updateAutotoolsGnuConfigScriptsHook }:

stdenv.mkDerivation rec {
  pname = "freesweep";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rwestlund";
    repo = "freesweep";
    rev = "v${version}";
    sha256 = "0grkwmz9whg1vlnk6gbr0vv9i2zgbd036182pk0xj4cavaj9rpjb";
  };

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];
  buildInputs = [ ncurses ];

  preConfigure = ''
    configureFlags="$configureFlags --with-prefsdir=$out/share"
  '';

  installPhase = ''
    runHook preInstall
    install -D -m 0555 freesweep $out/bin/freesweep
    install -D -m 0444 sweeprc $out/share/sweeprc
    install -D -m 0444 freesweep.6 $out/share/man/man6/freesweep.6
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A console minesweeper-style game written in C for Unix-like systems";
    homepage = https://github.com/rwestlund/freesweep;
    license = licenses.gpl2;
    maintainers = with maintainers; [ kierdavis ];
    platforms = platforms.unix;
  };
}
