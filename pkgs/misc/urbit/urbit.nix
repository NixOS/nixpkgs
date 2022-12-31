{ lib, stdenv, coreutils, pkgconfig                      # build/env
, cacert, ca-bundle, ivory-header                        # codegen
, curlUrbit, ent, gmp, h2o, libsigsegv, libuv, lmdb      # libs
, murmur3, openssl, softfloat3                           #
, urcrypt, zlib                                          #
, doCheck                ? true                          # opts
, enableParallelBuilding ? true
, dontStrip              ? true
, urbit-src }:

let

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

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    cacert
    ca-bundle
    curlUrbit
    ent
    gmp
    h2o
    ivory-header
    libsigsegv
    libuv
    lmdb
    murmur3
    openssl
    softfloat3
    urcrypt
    zlib
  ];

  # Ensure any `/usr/bin/env bash` shebang is patched.
  postPatch = ''
    patchShebangs ./configure
  '';

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

  inherit enableParallelBuilding doCheck dontStrip;

  meta = {
    description = "An operating function";
    homepage = "https://urbit.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.uningan ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
