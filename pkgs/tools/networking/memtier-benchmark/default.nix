{ stdenv, fetchFromGitHub, autoreconfHook
, pkgconfig, libevent, pcre, zlib, openssl
}:

stdenv.mkDerivation rec {
  pname = "memtier-benchmark";
  version = "1.2.17";

  src = fetchFromGitHub {
    owner  = "redislabs";
    repo   = "memtier_benchmark";
    rev    = "refs/tags/${version}";
    sha256 = "18cka6sv3w8ffa81126nzi04if9g1wd3i3apxsgmv7xm2p8fsa39";
  };

  patchPhase = ''
    substituteInPlace ./configure.ac \
      --replace '1.2.8' '${version}'
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libevent pcre zlib openssl ];

  meta = {
    description = "Redis and Memcached traffic generation and benchmarking tool";
    homepage    = https://github.com/redislabs/memtier_benchmark;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
