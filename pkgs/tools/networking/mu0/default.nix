{ fetchurl, stdenv, sqlite, pkgconfig, xapian, glib, gmime }:

stdenv.mkDerivation rec {
  name = "mu0-0.9.7";

  src = fetchurl {
    url = http://mu0.googlecode.com/files/mu-0.9.7.tar.gz;
    sha256 = "14nyn791ficyllj9idhiq3mncwnrg71lfxk126804dxba1l90r72";
  };

  buildInputs = [ sqlite pkgconfig xapian glib gmime ];

  /* The tests don't pass */
  doCheck = false;

  meta = {
    description = "mu is a collection of utilties for indexing and searching Maildirs";

    licenses = [ "GPLv3+" ];

    homepage = http://code.google.com/p/mu0/;

    platforms = stdenv.lib.platforms.all;
  };
}
