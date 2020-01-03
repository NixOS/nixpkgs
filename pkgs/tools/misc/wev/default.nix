{ stdenv, fetchurl
, pkg-config, scdoc
, wayland, wayland-protocols, libxkbcommon
}:

let
  version = "2019-08-11";
  commit = "47d17393473be152cf601272faf5704fff1c3f92";
in stdenv.mkDerivation {
  pname = "wev-unstable";
  inherit version;

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/wev/archive/${commit}.tar.gz";
    sha256 = "0a5kvrviz77bf7357gqs2iy7a1bvb3izgkmiv1rdxzzmihd563ga";
  };

  nativeBuildInputs = [ pkg-config scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Wayland event viewer";
    longDescription = ''
      This is a tool for debugging events on a Wayland window, analagous to the
      X11 tool xev.
    '';
    homepage = https://git.sr.ht/~sircmpwn/wev;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
