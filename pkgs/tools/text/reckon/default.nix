{ stdenv, lib, bundlerEnv, makeWrapper }:

stdenv.mkDerivation rec {
  name = "reckon-${version}";
  version = "0.4.4";

  env = bundlerEnv {
    name = "${name}-gems";

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
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
    maintainers = "mckean.kylej@gmail.com";
    platforms = platforms.unix;
  };
}
