{ urbit-src, stdenv, autoreconfHook, pkgconfig
, libaes_siv, openssl, secp256k1
}:

stdenv.mkDerivation rec {
  name = "urcrypt";
  src  = "${urbit-src}/pkg/urcrypt";

  # XX why are these required for darwin?
  dontDisableStatic = false;

  nativeBuildInputs =
    [ autoreconfHook pkgconfig ];

  propagatedBuildInputs =
    [ openssl secp256k1 libaes_siv ];
}
