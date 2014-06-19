{ fetchgit, stdenv, zlib, docbook2x, pcre, curl, libxml2, libevent, perl
, pkgconfig, protobuf, tokyocabinet, tokyotyrant, opencv, autoconf, automake
, libtool, seeks_confdir ? ""
}:

let
  rev = "1168b3a2f3111c3fca31dd961135194c3e8df5fd";
in
stdenv.mkDerivation {
  name = "seeks-${rev}";

  src = fetchgit {
    url = "git://github.com/beniz/seeks.git";
    inherit rev;
    sha256 = "159k9fk1ry8cybrq38jxm1qyxks9hlkfz624hzwxlzah6xb2j8a4";
  };

  buildInputs =
    [ zlib docbook2x pcre curl libxml2 libevent perl pkgconfig
      protobuf tokyocabinet tokyotyrant opencv autoconf automake libtool
    ];

  configureFlags =
    [ # Enable the built-in web server providing a web search interface.
      "--enable-httpserv-plugin=yes"
      "--with-libevent=${libevent}"
    ] ++ stdenv.lib.optional (seeks_confdir != "") "--sysconfdir=${seeks_confdir}";

  preConfigure = ''
    ./autogen.sh
  '';

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

    maintainers = [
      stdenv.lib.maintainers.ludo
      stdenv.lib.maintainers.matejc
    ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
