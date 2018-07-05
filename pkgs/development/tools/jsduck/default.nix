{ wrapCommand, lib, bundlerEnv }:

let
  pname = "jsduck";
  env = bundlerEnv {
    name = pname;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in wrapCommand pname {
  inherit (env.gems.jsduck) version;
  executable = "${env}/bin/jsduck";
  meta = with lib; {
    description = "Simple JavaScript Duckumentation generator.";
    homepage    = https://github.com/senchalabs/jsduck;
    license     = with licenses; gpl3;
    maintainers = with stdenv.lib.maintainers; [ periklis ];
    platforms   = platforms.unix;
  };
}
