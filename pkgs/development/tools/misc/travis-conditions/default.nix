{ lib, bundlerApp }:

bundlerApp rec {
  pname = "travis-conditions";
  gemdir = ./.;
  exes = [ pname ];

  meta = with lib; {
    description = "Boolean language for conditional builds, stages, jobs";
    homepage    = https://github.com/travis-ci/travis-conditions;
    license     = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
