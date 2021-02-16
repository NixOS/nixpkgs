{ lib
, stdenv
, fetchurl
, pkg-config
, scdoc
, wayland
, wayland-protocols
, libxkbcommon
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

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/wev";
    description = "Wayland event viewer";
    longDescription = ''
      This is a tool for debugging events on a Wayland window, analagous to the
      X11 tool xev.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.unix;
  };
}
