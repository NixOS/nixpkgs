{ stdenv, lib, fetchurl, lua, buildPackages }:

stdenv.mkDerivation rec {
  version = "4.0.11";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "1fqvxlpaxr80iykyvpf1fia8rxh4zz8paf5nnjncsssqwwxfflzw";
  };

  patchPhase = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace deps/hiredis/Makefile --replace "STLIB_MAKE_CMD=ar" "STLIB_MAKE_CMD=${buildPackages.binutils-unwrapped}/bin/${stdenv.cc.targetPrefix}ar"
    substituteInPlace deps/lua/Makefile --replace ranlib "${buildPackages.binutils-unwrapped}/bin/${stdenv.cc.targetPrefix}ranlib"
    substituteInPlace deps/lua/src/Makefile \
         --replace ranlib "${buildPackages.binutils-unwrapped}/bin/${stdenv.cc.targetPrefix}ranlib"
    substituteInPlace deps/Makefile --replace "AR=ar" "AR=${buildPackages.binutils-unwrapped}/bin/${stdenv.cc.targetPrefix}ar" \
         --replace "cd jemalloc && ./configure" "cd jemalloc && ./configure --host=${stdenv.cc.targetPrefix}"
  '';

  buildInputs = [ lua ];
  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  doCheck = false; # needs tcl

  meta = with stdenv.lib; {
    homepage = https://redis.io;
    description = "An open source, advanced key-value store";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.berdario ];
  };
}
