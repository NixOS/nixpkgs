{ fetchgit, stdenv, zlib, bzip2, docbook2x, pcre, curl, libxml2, libevent, perl
, pkgconfig, protobuf, tokyocabinet, tokyotyrant, opencv, autoconf, automake
, libtool, seeks_confDir ? ""
}:

stdenv.mkDerivation {
  name = "seeks-0.4.1";

  src = fetchgit {
    url = "git://github.com/beniz/seeks.git";
    rev = "1168b3a2f3111c3fca31dd961135194c3e8df5fd";
    sha256 = "18s2pxal9a2aayv63hc19vnkx5a5y9rhbipdpvkinbni5283iiar";
  };

  buildInputs =
    [ zlib bzip2 docbook2x pcre curl libxml2 libevent perl pkgconfig
      protobuf tokyocabinet tokyotyrant opencv autoconf automake libtool
    ];

  configureFlags =
    [ # Enable the built-in web server providing a web search interface.
      "--enable-httpserv-plugin=yes"
      "--with-libevent=${libevent.dev}"
    ];

  preConfigure = ''
    ./autogen.sh
  '';

  postInstall = stdenv.lib.optionalString (seeks_confDir != "") ''
    ln -svf ${seeks_confDir}/config $out/etc/seeks/config
    ln -svf ${seeks_confDir}/cf-config $out/etc/seeks/cf-config
    ln -svf ${seeks_confDir}/httpserv-config $out/etc/seeks/httpserv-config
    ln -svf ${seeks_confDir}/img-websearch-config $out/etc/seeks/img-websearch-config
    ln -svf ${seeks_confDir}/lsh-config $out/etc/seeks/lsh-config
    ln -svf ${seeks_confDir}/query-capture-config $out/etc/seeks/query-capture-config
    ln -svf ${seeks_confDir}/udb-service-config $out/etc/seeks/udb-service-config
    ln -svf ${seeks_confDir}/uri-capture-config $out/etc/seeks/uri-capture-config
    ln -svf ${seeks_confDir}/websearch-config $out/etc/seeks/websearch-config
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

    license = stdenv.lib.licenses.agpl3Plus;

    homepage = http://www.seeks-project.info/;

    maintainers = [
      stdenv.lib.maintainers.matejc
    ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
