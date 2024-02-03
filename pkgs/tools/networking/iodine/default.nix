{ lib, stdenv, fetchFromGitHub, zlib, nettools, nixosTests }:

stdenv.mkDerivation rec {
  pname = "iodine";
  version = "unstable-2019-09-27";

  src = fetchFromGitHub {
    owner = "yarrick";
    repo = "iodine";
    rev = "8e14f18";
    sha256 = "0k8m99qfjd5n6n56jnq85y7q8h2i2b8yw6ba0kxsz4jyx97lavg3";
  };

  buildInputs = [ zlib ];

  patchPhase = ''sed -i "s,/sbin/route,${nettools}/bin/route," src/tun.c'';

  env.NIX_CFLAGS_COMPILE = "-DIFCONFIGPATH=\"${nettools}/bin/\"";

  installFlags = [ "prefix=\${out}" ];

  passthru.tests = {
    inherit (nixosTests) iodine;
  };

  meta = {
    homepage = "http://code.kryo.se/iodine/";
    description = "Tool to tunnel IPv4 data through a DNS server";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
}
