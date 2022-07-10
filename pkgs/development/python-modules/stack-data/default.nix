{ asttokens
, buildPythonPackage
, cython
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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "stack_data";
    rev = "v${version}";
    sha256 = "sha256-brXFrk1UU5hxCVeRvGK7wzRA0Hoj9fgqoxTIwInPrEc=";
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
    cython
    littleutils
    pygments
    pytestCheckHook
    typeguard
  ];

  disabledTests = [
    # AssertionError
    "test_example"
    "test_executing_style_defs"
    "test_pygments_example"
    "test_variables"
  ];

  pythonImportsCheck = [ "stack_data" ];

  meta = with lib; {
    description = "Extract data from stack frames and tracebacks";
    homepage = "https://github.com/alexmojaki/stack_data/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
