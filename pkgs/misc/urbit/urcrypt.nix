{ lib
, urbit-src
, stdenv
, autoreconfHook
, pkgconfig
, libaes_siv
, openssl
, secp256k1
}:

stdenv.mkDerivation rec {
  pname = "urcrypt";
  version = urbit-src.rev;
  src  = "${urbit-src}/pkg/urcrypt";

  # XX why are these required for darwin?
  dontDisableStatic = false;

  nativeBuildInputs =
    [ autoreconfHook pkgconfig ];

  buildInputs =
    [ openssl secp256k1 libaes_siv ];

  meta = {
    description = "A library of cryptography routines used by urbit jets";
    homepage = "https://github.com/urbit/urbit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.uningan ];
    platforms = lib.platforms.unix;
  };
}
