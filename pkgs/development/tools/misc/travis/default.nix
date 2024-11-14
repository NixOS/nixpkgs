{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv {
  inherit ruby;
  pname = "travis";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "travis";

  meta = with lib; {
    description = "CLI and Ruby client library for Travis CI";
    mainProgram = "travis";
    homepage    = "https://github.com/travis-ci/travis.rb";
    license     = licenses.mit;
    maintainers = with maintainers; [ zimbatm nicknovitski ];
  };
}
