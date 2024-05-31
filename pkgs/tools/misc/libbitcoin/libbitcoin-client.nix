{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, boost, libbitcoin, libbitcoin-protocol }:

stdenv.mkDerivation rec {
  pname = "libbitcoin-client";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5qbxixaozHFsOcBxnuGEfNJyGL8UaYCOPwPakfc0bAg=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  propagatedBuildInputs = [ libbitcoin libbitcoin-protocol ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Bitcoin client query library";
    homepage = "https://github.com/libbitcoin/libbitcoin-client";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];

    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}
