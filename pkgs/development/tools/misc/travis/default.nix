{ stdenv, lib, bundlerEnv, ruby }:

stdenv.mkDerivation rec {
  name = "travis-${version}";
  version = env.gems.travis.version;

  env = bundlerEnv {
    inherit ruby;
    name = "${name}-gems";
    gemset = ./gemset.nix;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${env}/bin/travis $out/bin/travis
  '';

  meta = with lib; {
    description = "CLI and Ruby client library for Travis CI";
    homepage    = https://github.com/travis-ci/travis.rb;
    license     = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms   = ruby.meta.platforms;
  };
}
