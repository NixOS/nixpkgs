{ lib
, buildPythonApplication
, configparser
, enum34
, fetchFromGitHub
, functools32
, future
, isPy27
, mock
, pyahocorasick
, pytestCheckHook
, pyyaml
, requests
, responses
, unidiff
}:

buildPythonApplication rec {
  pname = "detect-secrets";
  version = "0.14.3";
  disabled = isPy27;

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c4hxih9ljmv0d3izq5idyspk5zci26gdb6lv9klwcshwrfkvxj0";
  };

  propagatedBuildInputs = [
    pyyaml
    requests
  ];

  checkInputs = [
    mock
    pyahocorasick
    pytestCheckHook
    responses
    unidiff
  ];

  disabledTests = [
    "TestMain"
    "TestPreCommitHook"
    "TestInitializeBaseline"
  ];

  pythonImportsCheck = [ "detect_secrets" ];

  meta = with lib; {
    description = "An enterprise friendly way of detecting and preventing secrets in code";
    homepage = "https://github.com/Yelp/detect-secrets";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
