{ lib, stdenv, fetchFromGitHub, autoreconfHook
, pkg-config, libevent, pcre, zlib, openssl
}:

stdenv.mkDerivation rec {
  pname = "memtier-benchmark";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner  = "redislabs";
    repo   = "memtier_benchmark";
    rev    = "refs/tags/${version}";
    sha256 = "sha256-1ZgSmHOLvPecqVN9P/Mr/2cOdbdl4oe4GgMjLaDX7YQ=";
  };

  patchPhase = ''
    substituteInPlace ./configure.ac \
      --replace '1.2.8' '${version}'
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libevent pcre zlib openssl ];

  meta = {
    description = "Redis and Memcached traffic generation and benchmarking tool";
    homepage    = "https://github.com/redislabs/memtier_benchmark";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
