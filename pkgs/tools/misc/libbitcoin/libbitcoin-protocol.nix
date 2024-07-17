{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  boost,
  libbitcoin,
  secp256k1,
  zeromq,
}:

stdenv.mkDerivation rec {
  pname = "libbitcoin-protocol";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xf0qQQnZ8h6ent1sgkVTo55+9drZM8Zbx0deYZnLBho=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libbitcoin
    secp256k1
  ];
  propagatedBuildInputs = [ zeromq ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Bitcoin Blockchain Query Protocol";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ asymmetric ];

    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}
