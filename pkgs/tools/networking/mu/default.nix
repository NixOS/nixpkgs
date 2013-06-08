{ fetchurl, stdenv, sqlite, pkgconfig, xapian, glib, gmime, texinfo, emacs, guile }:

stdenv.mkDerivation rec {
  version = "0.9.9";
  name = "mu-${version}";

  src = fetchurl {
    url = "https://mu0.googlecode.com/files/mu-${version}.tar.gz";
    sha256 = "04r0y05awsyb5hqwaxn1hq9jxijw20hwsgdbacqrma519f0y5y43";
  };

  buildInputs = [ sqlite pkgconfig xapian glib gmime texinfo emacs guile ];

  meta = {
    description = "mu is a collection of utilties for indexing and searching Maildirs";

    licenses = [ "GPLv3+" ];

    homepage = "http://www.djcbsoftware.nl/code/mu/";

    platforms = stdenv.lib.platforms.all;

    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
