{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "less-458";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/less/${name}.tar.gz";
    sha256 = "1b7wn1nk8qlzx20jmn9l6zcbw81n9g0w9zzhhzab6m6yks0wfdp5";
  };

  # Look for ‘sysless’ in /etc.
  configureFlags = "--sysconfdir=/etc";

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
