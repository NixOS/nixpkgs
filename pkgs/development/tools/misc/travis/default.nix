{ lib, bundlerEnv, ruby }:

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
