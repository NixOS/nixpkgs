{ stdenv, lib, bundlerEnv, makeWrapper, bundlerUpdateScript }:

stdenv.mkDerivation rec {
  pname = "jsduck";
  version = (import ./gemset.nix).jsduck.version;

  env = bundlerEnv {
    name = "${pname}";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  phases = [ "installPhase" ];

  buildInputs = [ env makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/jsduck $out/bin/jsduck
  '';

  passthru.updateScript = bundlerUpdateScript "jsduck";

  meta = with lib; {
    description = "Simple JavaScript Duckumentation generator.";
    homepage    = https://github.com/senchalabs/jsduck;
    license     = with licenses; gpl3;
    maintainers = with maintainers; [ periklis nicknovitski ];
    platforms   = platforms.unix;
  };
}
