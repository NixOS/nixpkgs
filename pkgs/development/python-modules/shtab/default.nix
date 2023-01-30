{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools-scm
, bashInteractive
}:

buildPythonPackage rec {
  pname = "shtab";
  version = "1.5.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FVV8AKe3PG387jarWYbXWxwVUAX6sM89KM8MuOr5cRw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    bashInteractive
    pytest-timeout
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=shtab --cov-report=term-missing --cov-report=xml" ""
  '';

  pythonImportsCheck = [
    "shtab"
  ];

  meta = with lib; {
    description = "Module for shell tab completion of Python CLI applications";
    homepage = "https://docs.iterative.ai/shtab/";
    changelog = "https://github.com/iterative/shtab/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
