<<<<<<< HEAD
{ lib, stdenv, fetchurl, fetchpatch, lua, jemalloc, pkg-config, nixosTests
=======
{ lib, stdenv, fetchurl, fetchpatch, lua, pkg-config, nixosTests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, tcl, which, ps, getconf
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
# dependency ordering is broken at the moment when building with openssl
, tlsSupport ? !stdenv.hostPlatform.isStatic, openssl
<<<<<<< HEAD

# Using system jemalloc fixes cross-compilation and various setups.
# However the experimental 'active defragmentation' feature of redis requires
# their custom patched version of jemalloc.
, useSystemJemalloc ? true
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "redis";
<<<<<<< HEAD
  version = "7.2.1";

  src = fetchurl {
    url = "https://download.redis.io/releases/${pname}-${version}.tar.gz";
    hash = "sha256-XHbZkKGxxflJvNHu2Q0Mik9wNpvb3LQCiMVh3fiJZ6Q=";
  };

  patches = lib.optionals useSystemJemalloc [
    # use system jemalloc
    (fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/redis/-/raw/102cc861713c796756abd541bf341a4512eb06e6/redis-5.0-use-system-jemalloc.patch";
      hash = "sha256-VPRfoSnctkkkzLrXEWQX3Lh5HmZaCXoJafyOG007KzM=";
=======
  version = "7.0.11";

  src = fetchurl {
    url = "https://download.redis.io/releases/${pname}-${version}.tar.gz";
    hash = "sha256-ziUNH7oELGE944oV1AiJt498ttVGGifjUBe6ObByIeM=";
  };

  patches = [
    # Fix flaky test tests/unit/memefficiency.tcl
    (fetchpatch {
      url = "https://github.com/redis/redis/commit/bfe50a30edff6837897964ac3374c082b0d9e5da.patch";
      sha256 = "sha256-0GMiygbO7LbL1rnuOByOJYE2BKUSI+yy6YH781E2zBw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lua ]
<<<<<<< HEAD
    ++ lib.optional useSystemJemalloc jemalloc
    ++ lib.optional withSystemd systemd
    ++ lib.optionals tlsSupport [ openssl ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/Makefile --replace "-flto" ""
  '';

  # More cross-compiling fixes.
  makeFlags = [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "AR=${stdenv.cc.targetPrefix}ar" "RANLIB=${stdenv.cc.targetPrefix}ranlib" ]
=======
    ++ lib.optional withSystemd systemd
    ++ lib.optionals tlsSupport [ openssl ];
  # More cross-compiling fixes.
  # Note: this enables libc malloc as a temporary fix for cross-compiling.
  # Due to hardcoded configure flags in jemalloc, we can't cross-compile vendored jemalloc properly, and so we're forced to use libc allocator.
  # It's weird that the build isn't failing because of failure to compile dependencies, it's from failure to link them!
  makeFlags = [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "AR=${stdenv.cc.targetPrefix}ar" "RANLIB=${stdenv.cc.targetPrefix}ranlib" "MALLOC=libc" ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optionals withSystemd [ "USE_SYSTEMD=yes" ]
    ++ lib.optionals tlsSupport [ "BUILD_TLS=yes" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  hardeningEnable = lib.optionals (!stdenv.isDarwin) [ "pie" ];
=======
  hardeningEnable = [ "pie" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [ "-std=c11" ]);

  # darwin currently lacks a pure `pgrep` which is extensively used here
  doCheck = !stdenv.isDarwin;
  nativeCheckInputs = [ which tcl ps ] ++ lib.optionals stdenv.hostPlatform.isStatic [ getconf ];
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
