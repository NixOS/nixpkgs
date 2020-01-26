{ stdenv, fetchurl, mecab, kytea, libedit, pkgconfig
, suggestSupport ? false, zeromq, libevent, msgpack
, lz4Support  ? false, lz4
, zlibSupport ? false, zlib
}:

stdenv.mkDerivation rec {

  pname = "groonga";
  version = "9.1.1";

  src = fetchurl {
    url    = "https://packages.groonga.org/source/groonga/${pname}-${version}.tar.gz";
    sha256 = "16i5bmypawxjac6g808qgr0z3rvla6g6dr586rmwl7sbq0z2nr82";
  };

  buildInputs = with stdenv.lib;
     [ pkgconfig mecab kytea libedit ]
    ++ optional lz4Support lz4
    ++ optional zlibSupport zlib
    ++ optionals suggestSupport [ zeromq libevent msgpack ];

  configureFlags = with stdenv.lib;
       optional zlibSupport "--with-zlib"
    ++ optional lz4Support  "--with-lz4";

  doInstallCheck    = true;
  installCheckPhase = "$out/bin/groonga --version";

  meta = with stdenv.lib; {
    homepage    = http://groonga.org/;
    description = "An open-source fulltext search engine and column store";
    license     = licenses.lgpl21;
    maintainers = [ maintainers.ericsagnes ];
    platforms   = platforms.unix;
    longDescription = ''
      Groonga is an open-source fulltext search engine and column store. 
      It lets you write high-performance applications that requires fulltext search.
    '';
  };

}
