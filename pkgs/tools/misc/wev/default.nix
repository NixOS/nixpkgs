{ stdenv, fetchurl
, pkg-config, scdoc, wayland
, wayland-protocols, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "wev";
  version = "1.0.0";

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/wev/archive/${version}.tar.gz";
    sha256 = "0vlxdkb59v6nb10j28gh1a56sx8jk7ak7liwzv911kpmygnls03g";
  };

  nativeBuildInputs = [ pkg-config scdoc wayland ];
  buildInputs = [ wayland-protocols libxkbcommon ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Wayland event viewer";
    longDescription = ''
      This is a tool for debugging events on a Wayland window, analagous to the
      X11 tool xev.
    '';
    homepage = "https://git.sr.ht/~sircmpwn/wev";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
