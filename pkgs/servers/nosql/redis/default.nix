{ lib, stdenv, fetchurl, lua, pkg-config, systemd, jemalloc, nixosTests
, tlsSupport ? true, openssl
}:

stdenv.mkDerivation rec {
  version = "6.0.10";
  pname = "redis";

  src = fetchurl {
    url = "http://download.redis.io/releases/${pname}-${version}.tar.gz";
    sha256 = "1gc529nfh8frk4pynyjlnmzvwa0j9r5cmqwyd7537sywz6abifvr";
  };

  # Cross-compiling fixes
  configurePhase = ''
    ${lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      # This fixes hiredis, which has the AR awkwardly coded.
      # Probably a good candidate for a patch upstream.
      makeFlagsArray+=('STLIB_MAKE_CMD=${stdenv.cc.targetPrefix}ar rcs $(STLIBNAME)')
    ''}
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lua ]
    ++ lib.optional (stdenv.isLinux && !stdenv.hostPlatform.isMusl) systemd
    ++ lib.optionals tlsSupport [ openssl ];
  # More cross-compiling fixes.
  # Note: this enables libc malloc as a temporary fix for cross-compiling.
  # Due to hardcoded configure flags in jemalloc, we can't cross-compile vendored jemalloc properly, and so we're forced to use libc allocator.
  # It's weird that the build isn't failing because of failure to compile dependencies, it's from failure to link them!
  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "AR=${stdenv.cc.targetPrefix}ar" "RANLIB=${stdenv.cc.targetPrefix}ranlib" "MALLOC=libc" ]
    ++ lib.optional (stdenv.isLinux && !stdenv.hostPlatform.isMusl) ["USE_SYSTEMD=yes"]
    ++ lib.optionals tlsSupport [ "BUILD_TLS=yes" ];

  enableParallelBuilding = true;

  doCheck = false; # needs tcl

  passthru.tests.redis = nixosTests.redis;

  meta = with lib; {
    homepage = "https://redis.io";
    description = "An open source, advanced key-value store";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ berdario globin ];
  };
}
