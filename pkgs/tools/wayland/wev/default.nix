{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, scdoc
, wayland-scanner
, wayland
, wayland-protocols
, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "wev";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = pname;
    rev = version;
    sha256 = "0l71v3fzgiiv6xkk365q1l08qvaymxd4kpaya6r2g8yzkr7i2hms";
  };

  strictDeps = true;
  # for scdoc
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [ pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols libxkbcommon ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/wev";
    description = "Wayland event viewer";
    longDescription = ''
      This is a tool for debugging events on a Wayland window, analogous to the
      X11 tool xev.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
    mainProgram = "wev";
  };
}
