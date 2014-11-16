{ stdenv, fetchurl, zlib, nettools }:

stdenv.mkDerivation rec {
  name = "iodine-0.6.0-rc1";

  src = fetchurl {
    url = "http://code.kryo.se/iodine/${name}.tar.gz";
    sha256 = "dacf950198b68fd1dae09fe980080155b0c75718f581c08e069eee0c1b6c5e60";
  };

  buildInputs = [ zlib ];

  patchPhase = ''sed -i "s,/sbin/ifconfig,${nettools}/bin/ifconfig,; s,/sbin/route,${nettools}/bin/route," src/tun.c'';

  installFlags = "prefix=\${out}";

  meta = {
    homepage = http://code.kryo.se/iodine/;
    description = "Tool to tunnel IPv4 data through a DNS server";
    license = stdenv.lib.licenses.isc;
  };
}
