{ lib, bundlerEnv, ruby }:

# Maintainer notes for updating
# 1. increment version number in Gemfile
# 2. run $ nix-shell --command "bundler install && bundix"
#    in the travis directory in nixpkgs

bundlerEnv {
  inherit ruby;
  pname = "travis";
  gemdir = ./.;

  meta = with lib; {
    description = "CLI and Ruby client library for Travis CI";
    homepage    = https://github.com/travis-ci/travis.rb;
    license     = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
