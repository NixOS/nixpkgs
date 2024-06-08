{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, makeWrapper
, pkg-config
, lrzsz
, ncurses
, libiconv
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "minicom";
  version = "2.9";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "minicom-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-+fKvHrApDXm94LItXv+xSDIE5zD7rTY5IeNSuzQglpg=";
  };

  buildInputs = [ ncurses ] ++ lib.optionals stdenv.isDarwin [ libiconv IOKit ];

  nativeBuildInputs = [ autoreconfHook makeWrapper pkg-config ];

  enableParallelBuilding = true;

  configureFlags = [
    "--sysconfdir=/etc"
    "--enable-lock-dir=/var/lock"
  ];

  patches = [ ./xminicom_terminal_paths.patch ];

  preConfigure = ''
    # Have `configure' assume that the lock directory exists.
    substituteInPlace configure \
      --replace 'test -d $UUCPLOCK' true
  '';

  postInstall = ''
    for f in $out/bin/*minicom ; do
      wrapProgram $f \
        --prefix PATH : ${lib.makeBinPath [ lrzsz ]}:$out/bin
    done
  '';

  meta = with lib; {
    description = "Modem control and terminal emulation program";
    homepage = "https://salsa.debian.org/minicom-team/minicom";
    license = licenses.gpl2Plus;
    longDescription = ''
      Minicom is a menu driven communications program. It emulates ANSI
      and VT102 terminals. It has a dialing directory and auto zmodem
      download.
    '';
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
