{ stdenv, fetchgit, autoreconfHook, pkgconfig, gtk3 }:

stdenv.mkDerivation {
  name = "screen-message-0.23";

  srcs = fetchgit {
    url = "git://git.nomeata.de/darcs-mirror-screen-message.debian.git";
    rev = "refs/tags/0_23-1";
    sha256 = "fddddd28703676b2908af71cca7225e6c7bdb15b2fdfd67679cac129028a431c";
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
