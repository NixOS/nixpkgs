{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, boost, libbitcoin, zeromq }:

stdenv.mkDerivation rec {
  pname = "libbitcoin-network";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zDT92bvA779mzTodpKugCoxapB6vY2jCMSGZEkJLTXQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libbitcoin zeromq ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Bitcoin P2P Network Library";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ asymmetric ];

    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}
