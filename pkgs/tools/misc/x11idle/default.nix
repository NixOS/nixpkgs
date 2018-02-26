{ stdenv, xlibs, fetchgit, libXScrnSaver, libX11 }:

stdenv.mkDerivation {
  name = "x11idle-unstable-2018-02-26";

  src = fetchgit {
    url = "https://code.orgmode.org/bzg/org-mode.git";
    rev = "e445894c0d35e670faf1566a3af365e719746172";
    sha256 = "1pdxn73pdb9fhch7nsr97n8vwbbw5xd47zjxlkxyqcrrc5plx978";
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
