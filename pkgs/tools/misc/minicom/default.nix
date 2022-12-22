{ lib, stdenv, fetchFromGitLab, autoreconfHook, makeWrapper, pkg-config
, lrzsz, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "minicom";
  version = "2.8";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "minicom-team";
    repo = pname;
    rev = version;
    sha256 = "165zhi88swvkhl3v17223r0f27hb3y0qzrgl51jkk0my2m4xscgg";
  };

  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin libiconv;

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
    license = licenses.gpl2;
    longDescription = ''
      Minicom is a menu driven communications program. It emulates ANSI
      and VT102 terminals. It has a dialing directory and auto zmodem
      download.
    '';
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
