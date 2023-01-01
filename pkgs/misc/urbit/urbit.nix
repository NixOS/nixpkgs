{ lib
, stdenv
, coreutils
, pkg-config
, cacert
, ca-bundle
, ivory-header
, curlMinimal
, ent
, gmp
, h2o-stable
, libsigsegv_patched
, libuv
, lmdb_patched
, murmur3
, openssl
, softfloat3
, urcrypt
, zlib
, urbit-src
}:let

  src = lib.cleanSource "${urbit-src}/pkg/urbit";

  version = builtins.readFile "${src}/version";

  # See https://github.com/urbit/urbit/issues/5561
  oFlags =
    if stdenv.isDarwin
    then [ "-O3" ]
    else [ "-O3" "-g" ];

in stdenv.mkDerivation {
  inherit src version;

  pname = "urbit";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    cacert
    ca-bundle
    curlMinimal
    ent
    gmp
    h2o-stable
    ivory-header
    libsigsegv_patched
    libuv
    lmdb_patched
    murmur3
    openssl
    softfloat3
    urcrypt
    zlib
  ];

  checkTarget = "test";

  installPhase = ''
    mkdir -p $out/bin
    cp ./build/urbit $out/bin/urbit
  '';

  dontDisableStatic = false;

  # CFLAGS = oFlags ++ [ "-Werror" ];
  CFLAGS = oFlags ++ [ "" ];

  MEMORY_DEBUG = false;
  CPU_DEBUG = false;
  EVENT_TIME_DEBUG = false;

  enableParallelBuilding = true;
  doCheck = true;

  # Ensure any `/usr/bin/env bash` shebang is patched.
  postPatch = ''
    patchShebangs ./configure
  '';

  meta = {
    description = "An operating function";
    homepage = "https://urbit.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.uningan ];
    platforms = lib.platforms.unix;
  };
}
