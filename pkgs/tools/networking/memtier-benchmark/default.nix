{ stdenv, fetchFromGitHub, autoreconfHook
, pkgconfig, libevent, pcre, zlib, openssl
}:

stdenv.mkDerivation rec {
  pname = "memtier-benchmark";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner  = "redislabs";
    repo   = "memtier_benchmark";
    rev    = "refs/tags/${version}";
    sha256 = "0m2qnnc71qpdj8w421bxn0zxz6ddvzy7b0n19jvyncnzvk1ff0sq";
  };

  patchPhase = ''
    substituteInPlace ./configure.ac \
      --replace '1.2.8' '${version}'
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libevent pcre zlib openssl ];

  meta = {
    description = "Redis and Memcached traffic generation and benchmarking tool";
    homepage    = "https://github.com/redislabs/memtier_benchmark";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
