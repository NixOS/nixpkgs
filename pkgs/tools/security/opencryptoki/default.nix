{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, bison
, flex
, openldap
, openssl
, trousers
, libcap
}:

stdenv.mkDerivation rec {
  pname = "opencryptoki";
  version = "3.23.0";

  src = fetchFromGitHub {
    owner = "opencryptoki";
    repo = "opencryptoki";
    rev = "v${version}";
    hash = "sha256-5FcvwGTzsL0lYrSYGlbSY89s6OKzg+2TRlwHlJjdzXo=";
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
    libcap
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "usermod" "true" \
      --replace-fail "useradd" "true" \
      --replace-fail "groupadd" "true" \
      --replace-fail "chmod" "true" \
      --replace-fail "chown" "true" \
      --replace-fail "chgrp" "true"
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
