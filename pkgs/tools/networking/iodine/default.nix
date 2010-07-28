{ stdenv, fetchurl, zlib, nettools }:

stdenv.mkDerivation rec {
  name = "iodine-0.4.1";

  src = fetchurl {
    url = "http://code.kryo.se/iodine/${name}.tar.gz";
    sha256 = "1d0v6wbrciwd0xi9khrna956v5wy7wy1inllzrn187as358kiiv5";
  };

  buildInputs = [ zlib ];

  patchPhase = ''sed -i "s,/sbin/ifconfig,${nettools}/sbin/ifconfig,; s,/sbin/route,${nettools}/sbin/route," src/tun.c'';

  installFlags = "prefix=\${out}";

  meta = {
    homepage = http://code.kryo.se/iodine/;
    description = "Tool to tunnel IPv4 data through a DNS server";
    license = "ISC";
  };
}
