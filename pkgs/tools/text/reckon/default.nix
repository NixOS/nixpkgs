{ stdenv, lib, bundlerEnv, bundlerUpdateScript, makeWrapper }:

stdenv.mkDerivation rec {
  name = "reckon-${version}";
  version = (import ./gemset.nix).reckon.version;

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

  passthru.updateScript = bundlerUpdateScript "reckon";

  meta = with lib; {
    description = "Flexibly import bank account CSV files into Ledger for command line accounting";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.unix;
  };
}
