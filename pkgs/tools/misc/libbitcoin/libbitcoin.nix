{ stdenv, lib, fetchurl, pkgconfig, autoreconfHook
, boost, libsodium, czmqpp, secp256k1 }:

let
  pname = "libbitcoin";
  version = "2.11.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/libbitcoin/libbitcoin/archive/v${version}.tar.gz";
    sha256 = "1lpdjm13kgs4fbp579bwfvws8yf9mnr5dw3ph8zxg2gf110h85sy";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ];

  propagatedBuildInputs = [ secp256k1 ];

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "C++ library for building bitcoin applications";
    homepage = https://libbitcoin.org/;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];

    # https://wiki.unsystem.net/en/index.php/Libbitcoin/License
    # AGPL with an additional clause
    license = licenses.agpl3;
  };
}
