{ stdenv, fetchurl, zlib, nettools }:

stdenv.mkDerivation rec {
  name = "iodine-0.7.0";

  src = fetchurl {
    url = "https://code.kryo.se/iodine/${name}.tar.gz";
    sha256 = "0gh17kcxxi37k65zm4gqsvbk3aw7yphcs3c02pn1c4s2y6n40axd";
  };

  buildInputs = [ zlib ];

  patchPhase = ''sed -i "s,/sbin/route,${nettools}/bin/route," src/tun.c'';

  NIX_CFLAGS_COMPILE = "-DIFCONFIGPATH=\"${nettools}/bin/\"";

  installFlags = [ "prefix=\${out}" ];

  meta = {
    homepage = http://code.kryo.se/iodine/;
    description = "Tool to tunnel IPv4 data through a DNS server";
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.unix;
  };
}
