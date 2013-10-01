{ fetchurl, stdenv, sqlite, pkgconfig, xapian, glib, gmime, texinfo, emacs, guile }:

stdenv.mkDerivation rec {
  version = "0.9.9.5";
  name = "mu-${version}";

  src = fetchurl {
    url = "https://mu0.googlecode.com/files/mu-${version}.tar.gz";
    sha256 = "1hwkliyb8fjrz5sw9fcisssig0jkdxzhccw0ld0l9a10q1l9mqhp";
  };

  buildInputs = [ sqlite pkgconfig xapian glib gmime texinfo emacs guile ];

  meta = {
    description = "A collection of utilties for indexing and searching Maildirs";
    license = "GPLv3+";
    homepage = "http://www.djcbsoftware.nl/code/mu/";
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ antono the-kenny ];
  };
}
