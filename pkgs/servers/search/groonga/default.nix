{ lib, stdenv, fetchurl, autoreconfHook, mecab, kytea, libedit, pkg-config
, suggestSupport ? false, zeromq, libevent, msgpack, openssl
, lz4Support  ? false, lz4
, zlibSupport ? true, zlib
}:

stdenv.mkDerivation rec {

  pname = "groonga";
  version = "11.0.9";

  src = fetchurl {
    url    = "https://packages.groonga.org/source/groonga/${pname}-${version}.tar.gz";
    sha256 = "sha256-yE/Ok0QNY9+a4vfNJWZjR4W8E/i+lw7T85X2+oOw8m4=";
  };

  preConfigure = ''
    # To avoid problems due to libc++abi 11 using `#include <version>`.
    rm version
  '';

  buildInputs = with lib;
     [ mecab kytea libedit openssl ]
    ++ optional lz4Support lz4
    ++ optional zlibSupport zlib
    ++ optionals suggestSupport [ zeromq libevent msgpack ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

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
