{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, openssl
, libevent
, pkg-config
, libprom
, libpromhttp
, libmicrohttpd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = version;
    sha256 = "1s7ncc82ny4bb3qkn3fqr0144xsr7h2y8xmzsf5037h6j8f7j3v8";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libevent
    libprom
    libpromhttp
    libmicrohttpd
  ];

  patches = [
    ./pure-configure.patch
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: ...-libprom-0.1.1/include/prom_collector_registry.h:37: multiple definition of
  #     `PROM_COLLECTOR_REGISTRY_DEFAULT'; ...-libprom-0.1.1/include/prom_collector_registry.h:37: first defined here
  # Should be fixed in libprom-1.2.0 and later: https://github.com/digitalocean/prometheus-client-c/pull/25
  NIX_CFLAGS_COMPILE = "-fcommon";

  passthru.tests.coturn = nixosTests.coturn;

  meta = with lib; {
    homepage = "https://coturn.net/";
    license = with licenses; [ bsd3 ];
    description = "A TURN server";
    platforms = platforms.all;
    broken = stdenv.isDarwin; # 2018-10-21
    maintainers = with maintainers; [ ralith _0x4A6F ];
  };
}
