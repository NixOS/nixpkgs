{lib, stdenv, fetchFromGitHub, libX11, libXi, libXt, libXfixes, libXext}:

stdenv.mkDerivation rec {
  version = "1.7";
  pname = "xbanish";

  buildInputs = [
    libX11 libXi libXt libXfixes libXext
  ];

  src = fetchFromGitHub {
    owner = "jcs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ic5f7zgc32p5g1wxas9y5h8dhik0pvsa8wmn6skdry56gw9vg9q";
  };

  makeFlags=[ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin $out/man/man1
  '';

  meta = {
    description = "Hides mouse pointer while not in use";
    longDescription = ''
      xbanish hides the mouse cursor when you start typing, and shows it again when
      the mouse cursor moves or a mouse button is pressed.  This is similar to
      xterm's pointerMode setting, but xbanish works globally in the X11 session.

      unclutter's -keystroke mode is supposed to do this, but it's broken[0].  I
      looked into fixing it, but the unclutter source code is terrible, so I wrote
      xbanish.

      The name comes from ratpoison's "banish" command that sends the cursor to the
      corner of the screen.
    '';
    license = lib.licenses.bsd3;
    maintainers = [lib.maintainers.choochootrain];
    platforms = lib.platforms.linux;
  };
}
