{ stdenv, fetchurl, pkgconfig, glib, gtk2, gtkmm }:

stdenv.mkDerivation rec {
  name = "nitrogen-1.5.2";

  src = fetchurl {
    url = "http://projects.l3ib.org/nitrogen/files/nitrogen-1.5.2.tar.gz";
    sha256 = "60a2437ce6a6c0ba44505fc8066c1973140d4bb48e1e5649f525c7b0b8bf9fd2";
  };
  buildInputs = [ glib gtk2 gtkmm pkgconfig ];

  NIX_LDFLAGS = "-lX11";

  patches = [ ./nitrogen-env-bash.patch ];

  meta = {
    description = "A background browser and setter for X windows";
    homepage = http://projects.l3ib.org/nitrogen/;
    platforms = stdenv.lib.platforms.linux;
  };
}
