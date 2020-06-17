{ lib, buildPythonApplication, fetchFromGitHub, isPy27, pyyaml, unidiff, configparser, enum34, future, functools32, mock, pytest }:

buildPythonApplication rec {
  pname = "detect-secrets";
  version = "0.12.4";

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "detect-secrets";
    rev = "v${version}";
    sha256 = "01y5xd0irxxib4wnf5834gwa7ibb81h5y4dl8b26gyzgvm5zfpk1";
  };

  propagatedBuildInputs = [ pyyaml ]
    ++ lib.optionals isPy27 [ configparser enum34 future functools32 ];

  checkInputs = [ mock pytest unidiff ];

  # deselect tests which require git setup
  checkPhase = ''
    PYTHONPATH=$PWD:$PYTHONPATH pytest \
      --deselect tests/main_test.py::TestMain \
      --deselect tests/pre_commit_hook_test.py::TestPreCommitHook \
      --deselect tests/core/baseline_test.py::TestInitializeBaseline
  '';

  meta = with lib; {
    description = "An enterprise friendly way of detecting and preventing secrets in code";
    homepage = "https://github.com/Yelp/detect-secrets";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
