{ stdenv, xlibs, fetchgit, libXScrnSaver, libX11 }:

stdenv.mkDerivation {
  name = "x11idle-unstable-2018-06-16";

  src = fetchgit {
    url = "https://code.orgmode.org/bzg/org-mode.git";
    rev = "54abd0f0ead0c98206eb551f639bc3cc727b71b2";
    sha256 = "08fc8r0krk5awb121a0x3azqx2az6xnbs0yj74d25fja0n2ap7q8";
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
