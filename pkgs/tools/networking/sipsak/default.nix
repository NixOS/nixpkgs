{ lib, stdenv, fetchFromGitHub, autoreconfHook, c-ares, openssl ? null }:

stdenv.mkDerivation rec {
  pname = "sipsak";
  version = "4.1.2.1";

  buildInputs = [
    autoreconfHook
    openssl
    c-ares
  ];

  # -fcommon: workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: transport.o:/build/source/sipsak.h:323: multiple definition of
  #     `address'; auth.o:/build/source/sipsak.h:323: first defined here
  NIX_CFLAGS_COMPILE = "-std=gnu89 -fcommon";

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

