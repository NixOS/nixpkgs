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
  version = "3.20.0";

  src = fetchFromGitHub {
    owner = "opencryptoki";
    repo = "opencryptoki";
    rev = "v${version}";
    hash = "sha256-Z11CDw9ykmJ7MI7I0H4Y/i+8/I+hRgC2frklYPP1di0=";
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
