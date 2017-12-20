{ stdenv, lib, fetchurl, pkgconfig, autoreconfHook
, boost, czmqpp, libbitcoin, secp256k1 }:

let
  pname = "libbitcoin-protocol";
  version = "3.4.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/libbitcoin/${pname}/archive/v${version}.tar.gz";
    sha256 = "0pz4cnw5xa603lf61fb5wk6ifcpgjvw4cksg05yjvdci55rwl3g3";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ secp256k1 ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "Bitcoin Blockchain Query Protocol";
    homepage = https://libbitcoin.org/;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ asymmetric ];

    license = licenses.agpl3;
  };
}
