{ lib, stdenv, fetchurl, lua, pkg-config, nixosTests
, tcl, which, ps, getconf
, withSystemd ? stdenv.isLinux && !stdenv.hostPlatform.isStatic, systemd
# dependency ordering is broken at the moment when building with openssl
, tlsSupport ? !stdenv.hostPlatform.isStatic, openssl
}:

stdenv.mkDerivation rec {
  pname = "redis";
  version = "7.0.8";

  src = fetchurl {
    url = "https://download.redis.io/releases/${pname}-${version}.tar.gz";
    hash = "sha256-BqM55JEwZ4Pc9VuX8VpdvL3AHMvebcIwJ8R1yrc16RQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lua ]
    ++ lib.optional withSystemd systemd
    ++ lib.optionals tlsSupport [ openssl ];
  # More cross-compiling fixes.
  # Note: this enables libc malloc as a temporary fix for cross-compiling.
  # Due to hardcoded configure flags in jemalloc, we can't cross-compile vendored jemalloc properly, and so we're forced to use libc allocator.
  # It's weird that the build isn't failing because of failure to compile dependencies, it's from failure to link them!
  makeFlags = [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "AR=${stdenv.cc.targetPrefix}ar" "RANLIB=${stdenv.cc.targetPrefix}ranlib" "MALLOC=libc" ]
    ++ lib.optionals withSystemd [ "USE_SYSTEMD=yes" ]
    ++ lib.optionals tlsSupport [ "BUILD_TLS=yes" ];

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isClang [ "-std=c11" ];

  # darwin currently lacks a pure `pgrep` which is extensively used here
  doCheck = !stdenv.isDarwin;
  checkInputs = [ which tcl ps ] ++ lib.optionals stdenv.hostPlatform.isStatic [ getconf ];
  checkPhase = ''
    runHook preCheck

    # disable test "Connect multiple replicas at the same time": even
    # upstream find this test too timing-sensitive
    substituteInPlace tests/integration/replication.tcl \
      --replace 'foreach mdl {no yes}' 'foreach mdl {}'

    substituteInPlace tests/support/server.tcl \
      --replace 'exec /usr/bin/env' 'exec env'

    sed -i '/^proc wait_load_handlers_disconnected/{n ; s/wait_for_condition 50 100/wait_for_condition 50 500/; }' \
      tests/support/util.tcl

    ./runtest \
      --no-latency \
      --timeout 2000 \
      --clients $NIX_BUILD_CORES \
      --tags -leaks \
      --skipunit integration/failover # flaky and slow

    runHook postCheck
  '';

  passthru.tests.redis = nixosTests.redis;

  meta = with lib; {
    homepage = "https://redis.io";
    description = "An open source, advanced key-value store";
    license = licenses.bsd3;
    platforms = platforms.all;
    changelog = "https://github.com/redis/redis/raw/${version}/00-RELEASENOTES";
    maintainers = with maintainers; [ berdario globin marsam ];
    mainProgram = "redis-cli";
  };
}
