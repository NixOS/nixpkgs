{ stdenv, bundlerEnv, ruby}:

let
  # To update, just run `nix-shell` in this directory.
  papertrail-env = bundlerEnv rec {
    name = "papertrail-env";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in stdenv.mkDerivation {
  name = "papertrail-${(import ./gemset.nix).papertrail.version}";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${papertrail-env}/bin/papertrail $out/bin/papertrail
  '';
}
