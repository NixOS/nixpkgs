{ lib, bundlerEnv, stdenv }:

let
  name = "hiera-eyaml-${env.gems.hiera-eyaml.version}";

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
    ln -s ${env}/bin/eyaml $out/bin/eyaml
  '';

  meta = with lib; {
    description = "Per-value asymmetric encryption of sensitive data for Hiera";
    homepage = https://github.com/TomPoulton/hiera-eyaml;
    license = licenses.mit;
    maintainers = [ maintainers.benley ];
    platforms = platforms.unix;
  };
}
