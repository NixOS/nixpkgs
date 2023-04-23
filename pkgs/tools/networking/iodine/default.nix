{ lib, stdenv, fetchFromGitHub, zlib, nettools, nixosTests }:

stdenv.mkDerivation rec {
  pname = "iodine";
  version = "v0.8.0";

  src = fetchFromGitHub {
    owner = "yarrick";
    repo = "iodine";
    rev = "607b9d3";
    sha256 = "sha256-0vDl/F/57puugrEdOtdlpNPMF9ugO7TP3KLWo/7bP2k=";
  };

  buildInputs = [ zlib ];

  patchPhase = ''sed -i "s,/sbin/route,${nettools}/bin/route," src/tun.c'';

  env.NIX_CFLAGS_COMPILE = "-DIFCONFIGPATH=\"${nettools}/bin/\" -DROUTEPATH=\"${nettools}/bin/\"";

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
