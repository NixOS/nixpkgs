{ asttokens
, buildPythonPackage
, executing
, fetchFromGitHub
, git
, lib
, littleutils
, pure-eval
, pygments
, pytestCheckHook
, setuptools-scm
, toml
, typeguard
}:

buildPythonPackage rec {
  pname = "stack-data";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "stack_data";
    rev = "v${version}";
    sha256 = "sha256-dRIRDMq0tc1QuBHvppPwJA5PVGHyVRhoBlX5BsdDzec=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    git
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = [
    asttokens
    executing
    pure-eval
  ];

  checkInputs = [
    littleutils
    pygments
    pytestCheckHook
    typeguard
  ];

  disabledTests = [
    # AssertionError
    "test_variables"
    "test_example"
  ];

  pythonImportsCheck = [ "stack_data" ];

  meta = with lib; {
    description = "Extract data from stack frames and tracebacks";
    homepage = "https://github.com/alexmojaki/stack_data/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
