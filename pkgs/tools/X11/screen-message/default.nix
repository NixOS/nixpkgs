{ stdenv, fetchurl, autoreconfHook, pkgconfig, gtk3 }:

stdenv.mkDerivation rec {
  name = "screen-message-${version}";
  version = "0.24";

  src = fetchurl {
    url = "mirror://debian/pool/main/s/screen-message/screen-message_${version}.orig.tar.gz";
    sha256 = "1v03axr7471fmzxccl3ckv73j8gfcj615y5maxvm5phy0sd6rl49";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gtk3 ];

  # screen-message installs its binary in $(prefix)/games per default
  makeFlags = [ "execgamesdir=$(out)/bin" ];

  meta = {
    homepage = "http://darcs.nomeata.de/cgi-bin/darcsweb.cgi?r=screen-message.debian";
    description = "Displays a short text fullscreen in an X11 window";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.fpletz ];
    platforms = stdenv.lib.platforms.unix;
  };
}
