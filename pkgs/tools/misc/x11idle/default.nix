{ stdenv, xlibs, fetchgit, libXScrnSaver, libX11 }:

stdenv.mkDerivation {
  name = "x11idle-unstable-2017-07-01";

  src = fetchgit {
    url = "git://orgmode.org/org-mode.git";
    rev = "fbd865941f3105f689f78bf053bb3b353b9b8a23";
    sha256 = "0ma3m48f4s38xln0gl1ww9i5x28ij0ipxc94kx5h2931zy7lqzvz";
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
    homepage = "http://orgmode.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.swflint ];
  };
}
