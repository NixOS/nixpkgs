{ stdenv, xlibs, fetchgit, libXScrnSaver, libX11 }:

stdenv.mkDerivation rec {

  version = "9.1.9";
  name = "x11idle-org-${version}";

  src = fetchgit {
    url = "https://code.orgmode.org/bzg/org-mode.git";
    rev = "release-${version}";
    sha256 = "0wly0nyd8qmchrjfx9079iipav8784kszagp5j3z06b9768cp8jr";
    fetchSubmodules = true;
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
