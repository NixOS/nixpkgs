{ stdenv, lib, bundlerEnv, makeWrapper, }:

stdenv.mkDerivation rec {
  pname = "jsduck";
  name = "${pname}-${version}";
  version = "5.3.4";

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

  meta = with lib; {
    description = "Simple JavaScript Duckumentation generator.";
    homepage    = https://github.com/senchalabs/jsduck;
    license     = with licenses; gpl3;
    maintainers = with stdenv.lib.maintainers; [ periklis ];
    platforms   = platforms.unix;
  };
}
