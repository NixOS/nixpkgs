# Env to update Gemfile.lock / gemset.nix
{
  pkgs ? import ../../../../.. { },
}:
pkgs.stdenv.mkDerivation {
  name = "env";
  buildInputs = with pkgs; [
    ruby.devEnv
    gnumake
    bundix
  ];
}
