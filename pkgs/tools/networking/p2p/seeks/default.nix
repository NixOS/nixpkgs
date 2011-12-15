{ fetchurl, stdenv, zlib, docbook2x, pcre, curl, libxml2, libevent, perl
, pkgconfig, protobuf, tokyocabinet, tokyotyrant, opencv
}:

let version = "0.4.0"; in
stdenv.mkDerivation {
  name = "seeks-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/seeks/hippy/seeks-${version}.tar.gz";
    sha256 = "1y91dmd0b0yj5036x8kk92iy88dsnzdwhhz23ba9lp96vpafd2ky";
  };

  buildInputs =
    [ zlib docbook2x pcre curl libxml2 libevent perl pkgconfig
      protobuf tokyocabinet tokyotyrant opencv
    ];

  configureFlags =
    [ # Enable the built-in web server providing a web search interface.
      # See <http://www.seeks-project.info/wiki/index.php/Seeks_On_Web>.
      "--enable-httpserv-plugin=yes"
      "--with-libevent=${libevent}"
    ];

  # FIXME: Test suite needs <https://code.google.com/p/googletest/>.
  doCheck = false;

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
