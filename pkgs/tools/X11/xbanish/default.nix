{stdenv, fetchFromGitHub, libX11, libXi, libXt, libXfixes, libXext}:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "xbanish-${version}";

  buildInputs = [
    libX11 libXi libXt libXfixes libXext
  ];

  src = fetchFromGitHub {
    owner = "jcs";
    repo = "xbanish";
    rev = "5cbc51a88739bc7ebe3ea3114ec423890d180146";
    sha256 = "0n5aiqfwx9ga8qjszymfmbnmygcracrgvvpmgll7mflp2jnvzq6j";
  };

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
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
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.choochootrain];
    platforms = stdenv.lib.platforms.linux;
  };
}
