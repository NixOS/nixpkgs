{ stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "551";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ggyjl3yzn7c450zk1rixi9ls6asdhgqynhk34zsd0ckhmsm45pz";
  };

  configureFlags = [ "--sysconfdir=/etc" ] # Look for ‘sysless’ in /etc.
    ++ stdenv.lib.optional lessSecure [ "--with-secure" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ eelco dtzWill ];
  };
}
