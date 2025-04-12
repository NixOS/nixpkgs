{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "securityreporter";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dongit-org";
    repo = "python-reporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-fpsvjbPE6iaOmLxykGSkCjkhFTmb8xhXa8pDrWN66KM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    docker
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "reporter" ];

  disabledTestPaths = [
    # Test require a running Docker instance
    "tests/functional/"
  ];

  meta = with lib; {
    description = "Python wrapper for the Reporter API";
    homepage = "https://github.com/dongit-org/python-reporter";
    changelog = "https://github.com/dongit-org/python-reporter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
