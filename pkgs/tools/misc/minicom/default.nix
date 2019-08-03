{ stdenv, fetchgit, autoreconfHook, makeWrapper, pkgconfig
, lrzsz, ncurses, libiconv }:

stdenv.mkDerivation rec {
  name = "minicom-${version}";
  version = "2.7.1";

  # The repository isn't tagged properly, so we need to use commit refs
  src = fetchgit {
    url    = "https://salsa.debian.org/minicom-team/minicom.git";
    rev    = "6ea8033b6864aa35d14fb8b87e104e4f783635ce";
    sha256 = "0j95727xni4r122dalp09963gvc1nqa18l1d4wzz8746kw5s2rrb";
  };

  buildInputs = [ ncurses ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig ];

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
        --prefix PATH : ${stdenv.lib.makeBinPath [ lrzsz ]}:$out/bin
    done
  '';

  meta = with stdenv.lib; {
    description = "Modem control and terminal emulation program";
    homepage = https://salsa.debian.org/minicom-team/minicom;
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
