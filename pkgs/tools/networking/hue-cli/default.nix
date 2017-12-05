{ bundlerEnv, ruby }:

bundlerEnv rec {
  name = "hue-cli-${version}";

  version = (import gemset).hue-cli.version;
  inherit ruby;
  gemdir = ./.;
  gemset = ./gemset.nix;
}
