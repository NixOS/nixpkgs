{ stdenv, fetchdarcs, autoreconfHook, pkgconfig, gtk3 }:

stdenv.mkDerivation {
  name = "screen-message-0.23";

  src = fetchdarcs {
    url = "http://darcs.nomeata.de/screen-message.debian";
    rev = "0.23-1";
  };

  buildInputs = [ autoreconfHook pkgconfig gtk3 ];

  # screen-message installs its binary in $(prefix)/games per default
  makeFlags = [ "execgamesdir=$(out)/bin" ];

  meta = {
    homepage = "http://darcs.nomeata.de/cgi-bin/darcsweb.cgi?r=screen-message.debian";
    description = "Displays a short text fullscreen in an X11 window";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.fpletz ];
  };
}
