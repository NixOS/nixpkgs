{ stdenv, fetchFromGitHub, autoreconfHook
, pkgconfig, libevent, pcre, zlib, openssl
}:

stdenv.mkDerivation rec {
  name = "memtier-benchmark-${version}";
  version = "1.2.11";

  src = fetchFromGitHub {
    owner  = "redislabs";
    repo   = "memtier_benchmark";
    rev    = "refs/tags/${version}";
    sha256 = "0a1lz4j9whj6yf94xn7rna00abgrv2qs30vmpns1n9zqlpaj6b6a";
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
