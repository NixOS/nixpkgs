{ bundlerEnv, lib, stdenv }:

let
  name = "riemann-dash-${env.gems.riemann-dash.version}";

  env = bundlerEnv {
    inherit name;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in stdenv.mkDerivation {
  inherit name;
  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${env}/bin/riemann-dash $out/bin/riemann-dash
  '';

  meta = with lib; {
    description = "A javascript, websockets-powered dashboard for Riemann";
    homepage = https://github.com/riemann/riemann-dash;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
