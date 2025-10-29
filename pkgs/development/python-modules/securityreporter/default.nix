{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "securityreporter";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dongit-org";
    repo = "python-reporter";
    tag = "v${version}";
    hash = "sha256-YvUDgsKM0JUajp8JAR2vj30QsNtcGvADGCZ791ZZD/8=";
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
