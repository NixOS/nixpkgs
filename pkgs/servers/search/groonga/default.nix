{ lib, stdenv, fetchurl, mecab, kytea, libedit, pkg-config
, suggestSupport ? false, zeromq, libevent, msgpack
, lz4Support  ? false, lz4
, zlibSupport ? false, zlib
}:

stdenv.mkDerivation rec {

  pname = "groonga";
  version = "11.0.4";

  src = fetchurl {
    url    = "https://packages.groonga.org/source/groonga/${pname}-${version}.tar.gz";
    sha256 = "sha256-a/IMroZ1zAgIv7Cx4kkj5byIMoC0o+seHhqVLaUUSqc=";
  };

  buildInputs = with lib;
     [ pkg-config mecab kytea libedit ]
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
