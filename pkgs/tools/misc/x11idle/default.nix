{ stdenv, xlibs, fetchgit, libXScrnSaver, libX11 }:

stdenv.mkDerivation {
  name = "x11idle-unstable-2018-02-26";

  src = fetchgit {
    url = "https://code.orgmode.org/bzg/org-mode.git";
    rev = "a23be068f64879310fae3d34ebf4cc6b8aaaa4d7";
    sha256 = "1nn3zqaj43lx5xr2s1dw6ah1sdjy6mz2zsx993p4j58qnb13lvdr";
  };

  buildInputs = [ libXScrnSaver libX11 ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    gcc -lXss -lX11 $src/contrib/scripts/x11idle.c -o $out/bin/x11idle
  '';

  meta = with stdenv.lib; {
    description = ''
      Compute consecutive idle time for current X11 session with millisecond resolution
    '';
    longDescription = ''
      Idle time passes when the user does not act, i.e. when the user doesn't move the mouse or use the keyboard.
    '';
    homepage = http://orgmode.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.swflint ];
  };
}
