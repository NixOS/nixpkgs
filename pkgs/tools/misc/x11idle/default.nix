{ lib, stdenv, fetchurl, libXScrnSaver, libX11 }:

stdenv.mkDerivation rec {
  version = "9.2.4";
  pname = "x11idle-org";

  src = fetchurl {
    url = "https://code.orgmode.org/bzg/org-mode/raw/release_${version}/contrib/scripts/x11idle.c";
    sha256 = "0fc5g57xd6bmghyl214gcff0ni3idv33i3gkr339kgn1mdjljv5g";
  };

  buildInputs = [ libXScrnSaver libX11 ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    gcc -lXss -lX11 $src -o $out/bin/x11idle
  '';

  meta = with lib; {
    description = ''
      Compute consecutive idle time for current X11 session with millisecond resolution
    '';
    longDescription = ''
      Idle time passes when the user does not act, i.e. when the user doesn't move the mouse or use the keyboard.
    '';
    homepage = "https://orgmode.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.swflint ];
    mainProgram = "x11idle";
  };
}
