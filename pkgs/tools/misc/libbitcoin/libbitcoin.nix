{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  boost,
  secp256k1,
}:

stdenv.mkDerivation rec {
  pname = "libbitcoin";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7fxj2hnuGRUS4QSQ1w0s3looe9pMvE2U50/yhNyBMf0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [ secp256k1 ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "C++ library for building bitcoin applications";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}
