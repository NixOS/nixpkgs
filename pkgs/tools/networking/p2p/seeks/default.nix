{ fetchurl, stdenv, zlib, docbook2x, pcre, curl, libxml2, libevent, perl
, autoconf, automake, libtool }:

let version = "0.2.3a"; in
stdenv.mkDerivation {
  name = "seeks-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/seeks/solo/seeks_solo_stable-${version}.src.tar.gz";
    sha256 = "0hjaqwcaa19qbq28y5gq0415fz10vx034aghqa01hrhhl9yrjvc4";
  };

  buildInputs =
    [ zlib docbook2x pcre curl libxml2 libevent perl
      autoconf automake libtool
    ];

  # The tarball doesn't contain `configure' & co.  Sigh...
  preConfigure = "autoreconf -vfi";

  configureFlags =
    [ # Enable the built-in web server providing a web search interface.
      # See <http://www.seeks-project.info/wiki/index.php/Seeks_On_Web>.
      "--enable-httpserv-plugin=yes"
      "--with-libevent=${libevent}"
    ];

  meta = {
    description = "Seeks, a social web search engine";

    longDescription =
      '' Seeks is a free and open technical design and application for
         enabling social websearch.  Its specific purpose is to regroup users
         whose queries are similar so they can share both the query results
         and their experience on these results.  On this basis, Seeks allows
         for true real-time, decentralized, websearch to emerge.

         In the long term, there is no need for web crawlers and third-party
         web indexes as users can push content directly to search groups.
      '';

    license = "AGPLv3+";

    homepage = http://www.seeks-project.info/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
