{ fetchFromGitHub, fetchpatch, ncurses, lib, stdenv,
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

  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchains
    # like upstream gcc-10+ or clang-13:
    #  https://github.com/rwestlund/freesweep/pull/8
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/rwestlund/freesweep/commit/a86245df4f3ff276a393f799d737d28a5cb0a5a8.patch";
      sha256 = "13gs3bjb68ixyn9micza7gjd489rd2f5pdrv6sip9fsa6ya29xky";
    })

    # Pull fix pending upstream inclusion for ncurses-6.3:
    #  https://github.com/rwestlund/freesweep/pull/10
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/rwestlund/freesweep/commit/b0aef2bd0b2409d1e859af7d29bf2d86fc7bcea7.patch";
      sha256 = "1nzvmvxhjxgm8228h1zz16w62iy6lak5sibif1s1f6p1ssn659jp";
    })
  ];

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

  meta = with lib; {
    description = "A console minesweeper-style game written in C for Unix-like systems";
    homepage = "https://github.com/rwestlund/freesweep";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kierdavis ];
    platforms = platforms.unix;
  };
}
