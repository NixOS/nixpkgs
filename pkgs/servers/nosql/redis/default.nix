{ stdenv, fetchurl, lua, jemalloc, nixosTests }:

stdenv.mkDerivation rec {
  version = "5.0.7";
  pname = "redis";

  src = fetchurl {
    url = "http://download.redis.io/releases/${pname}-${version}.tar.gz";
    sha256 = "0ax8sf3vw0yadr41kzc04917scrg5wir1d94zmbz00b8pzm79nv1";
  };

  # Cross-compiling fixes
  configurePhase = ''
    ${stdenv.lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      # This fixes hiredis, which has the AR awkwardly coded.
      # Probably a good candidate for a patch upstream.
      makeFlagsArray+=('STLIB_MAKE_CMD=${stdenv.cc.targetPrefix}ar rcs $(STLIBNAME)')
    ''}
  '';

  buildInputs = [ lua ];
  # More cross-compiling fixes.
  # Note: this enables libc malloc as a temporary fix for cross-compiling.
  # Due to hardcoded configure flags in jemalloc, we can't cross-compile vendored jemalloc properly, and so we're forced to use libc allocator.
  # It's weird that the build isn't failing because of failure to compile dependencies, it's from failure to link them!
  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "AR=${stdenv.cc.targetPrefix}ar" "RANLIB=${stdenv.cc.targetPrefix}ranlib" "MALLOC=libc" ];

  enableParallelBuilding = true;

  doCheck = false; # needs tcl

  passthru.tests.redis = nixosTests.redis;

  meta = with stdenv.lib; {
    homepage = https://redis.io;
    description = "An open source, advanced key-value store";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ berdario globin ];
  };
}
