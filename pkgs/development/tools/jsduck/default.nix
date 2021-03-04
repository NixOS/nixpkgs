{ stdenv, lib, bundlerEnv, makeWrapper, bundlerUpdateScript }:

let
  pname = "jsduck";
  env = bundlerEnv {
    name = pname;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
stdenv.mkDerivation rec {
  inherit pname;
  version = (import ./gemset.nix).jsduck.version;

  phases = [ "installPhase" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ env ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/jsduck $out/bin/jsduck
  '';

  passthru.updateScript = bundlerUpdateScript "jsduck";

  meta = with lib; {
    description = "Simple JavaScript Duckumentation generator";
    homepage    = "https://github.com/senchalabs/jsduck";
    license     = with licenses; gpl3;
    maintainers = with maintainers; [ periklis nicknovitski ];
    platforms   = platforms.unix;
  };
}
