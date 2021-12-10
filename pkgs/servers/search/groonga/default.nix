{ lib, stdenv, fetchurl, mecab, kytea, libedit, pkg-config
, suggestSupport ? false, zeromq, libevent, msgpack, openssl
, lz4Support  ? false, lz4
, zlibSupport ? true, zlib
}:

stdenv.mkDerivation rec {

  pname = "groonga";
  version = "11.1.0";

  src = fetchurl {
    url    = "https://packages.groonga.org/source/groonga/${pname}-${version}.tar.gz";
    sha256 = "sha256-di1uzTZxeRLevcSS5d/yba5Y6tdy21H2NgU7ZrZTObI=";
  };

  buildInputs = with lib;
     [ pkg-config mecab kytea libedit openssl ]
    ++ optional lz4Support lz4
    ++ optional zlibSupport zlib
    ++ optionals suggestSupport [ zeromq libevent msgpack ];

  configureFlags = with lib;
       optional zlibSupport "--with-zlib"
    ++ optional lz4Support  "--with-lz4";

  doInstallCheck    = true;
  installCheckPhase = "$out/bin/groonga --version";

  meta = with lib; {
    homepage    = "https://groonga.org/";
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
