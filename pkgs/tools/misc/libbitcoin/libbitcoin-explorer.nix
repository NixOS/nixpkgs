{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, boost, libbitcoin-client, libbitcoin-network }:

stdenv.mkDerivation rec {
  pname = "libbitcoin-explorer";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NUAtjrfRbZg5ewQo4PZ1HEoG8GRrsPcNb78UYMHqdyo=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libbitcoin-client libbitcoin-network ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-bash-completiondir=$out/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Bitcoin command line tool";
    homepage = "https://github.com/libbitcoin/libbitcoin-explorer";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ asymmetric ];

    # AGPL with a lesser clause
    license = licenses.agpl3;
  };
}
