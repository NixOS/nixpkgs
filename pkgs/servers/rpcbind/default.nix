{ fetchurl, stdenv, libtirpc }:

stdenv.mkDerivation rec {
  name = "rpcbind-0.2.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/rpcbind/rpcbind-0.2.0.tar.bz2";
    sha256 = "c92f263e0353887f16379d7708ef1fb4c7eedcf20448bc1e4838f59497a00de3";
  };

  patches = [ ./sunrpc.patch ];

  preConfigure = ''
    export CPPFLAGS=-I${libtirpc}/include/tirpc
  '';

  buildInputs = [ libtirpc ];

  meta = {
    description = "ONC RPC portmapper";
    license = stdenv.lib.licenses.bsd3;
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
  };
}
