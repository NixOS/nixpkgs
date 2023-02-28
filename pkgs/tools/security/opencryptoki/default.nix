{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, bison
, flex
, openldap
, openssl
, trousers
}:

stdenv.mkDerivation rec {
  pname = "opencryptoki";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "opencryptoki";
    repo = "opencryptoki";
    rev = "v${version}";
    hash = "sha256-ym13I34H3d1JuVBnItkceUbqpjYFhD+mPgWYHPetF7Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  buildInputs = [
    openldap
    openssl
    trousers
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "usermod" "true" \
      --replace "groupadd" "true" \
      --replace "chmod" "true" \
      --replace "chgrp" "true"
  '';

  configureFlags = [
    "--prefix="
    "--disable-ccatok"
    "--disable-icatok"
  ];

  enableParallelBuilding = true;

  installFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  meta = with lib; {
    changelog   = "https://github.com/opencryptoki/opencryptoki/blob/${src.rev}/ChangeLog";
    description = "PKCS#11 implementation for Linux";
    homepage    = "https://github.com/opencryptoki/opencryptoki";
    license     = licenses.cpl10;
    maintainers = [ ];
    platforms   = platforms.unix;
  };
}
