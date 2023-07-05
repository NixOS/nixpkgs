{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, bashInteractive
}:

buildPythonPackage rec {
  pname = "shtab";
  version = "1.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qhWkUprDEFRvb9/0dGWBjyIFQY08sAqFSl5jYGtN6Z8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=shtab --cov-report=term-missing --cov-report=xml" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    bashInteractive
    pytest-timeout
    pytestCheckHook
  ];

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
