{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook
, boost, libbitcoin, secp256k1, zeromq }:

let
  pname = "libbitcoin-protocol";
  version = "3.4.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wrlzani3wdjkmxqwjh30i8lg3clrzwcx2di7c9sdpnsbda985gb";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libbitcoin secp256k1 ];
  propagatedBuildInputs = [ zeromq ];

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

    # AGPL with a lesser clause
    license = licenses.agpl3;
  };
}
