{ lib, stdenv, fetchFromGitHub, autoreconfHook, c-ares, openssl ? null }:

stdenv.mkDerivation rec {
  pname = "sipsak";
  version = "4.1.2.1";

  buildInputs = [
    autoreconfHook
    openssl
    c-ares
  ];

  NIX_CFLAGS_COMPILE = "--std=gnu89";

  src = fetchFromGitHub {
    owner = "sipwise";
    repo = "sipsak";
    rev = "mr${version}";
    hash = "sha256-y9P6t3xjazRNT6lDZAx+CttdyXruC6Q14b8XF9loeU4=";
  };

  meta = with lib; {
    homepage = "https://github.com/sipwise/sipsak";
    description = "SIP Swiss army knife";
    license = lib.licenses.gpl2;
    maintainers = with maintainers; [ sheenobu ];
    platforms = with platforms; unix;
  };

}

