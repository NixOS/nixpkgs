{ lib, stdenv, fetchurl, mecab, kytea, libedit, pkg-config, libxcrypt
, suggestSupport ? false, zeromq, libevent, msgpack, openssl
, lz4Support  ? false, lz4
, zlibSupport ? true, zlib
}:

stdenv.mkDerivation rec {

  pname = "groonga";
  version = "12.1.0";

  src = fetchurl {
    url    = "https://packages.groonga.org/source/groonga/${pname}-${version}.tar.gz";
    sha256 = "sha256-pLU1ifcm8jfqr9jQMjNbccNprDz6uZ9zNcXRJ5IBOdc=";
  };

  buildInputs = with lib;
     [ mecab kytea libedit openssl libxcrypt ]
    ++ optional lz4Support lz4
    ++ optional zlibSupport zlib
    ++ optionals suggestSupport [ zeromq libevent msgpack ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = with lib;
       optional zlibSupport "--with-zlib"
    ++ optional lz4Support  "--with-lz4";

  doInstallCheck    = true;
  installCheckPhase = "$out/bin/groonga --version";

  meta = with lib; {
    homepage    = "https://groonga.org/";
    description = "An open-source fulltext search engine and column store";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ ericsagnes ivan ];
    platforms   = platforms.unix;
    longDescription = ''
      Groonga is an open-source fulltext search engine and column store.
      It lets you write high-performance applications that requires fulltext search.
    '';
  };

}
