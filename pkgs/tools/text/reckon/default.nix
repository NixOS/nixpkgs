{ stdenv, lib, bundlerEnv, makeWrapper }:

stdenv.mkDerivation rec {
  name = "reckon-${version}";
  version = "0.4.4";

  env = bundlerEnv {
    name = "${name}-gems";

    gemdir = ./.;
  };

  phases = [ "installPhase" ];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/reckon $out/bin/reckon
  '';

  meta = with lib; {
    description = "Flexibly import bank account CSV files into Ledger for command line accounting";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
