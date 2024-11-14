{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "swisshydrodata";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = "swisshydrodata";
    rev = "refs/tags/${version}";
    hash = "sha256-RcVwo61HZ02JEOHsSY/W8j2OTBN25oR2JunLZ5i6yVI=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "swisshydrodata" ];

  meta = with lib; {
    description = "Python client to get data from the Swiss federal Office for Environment FEON";
    homepage = "https://github.com/bouni/swisshydrodata";
    changelog = "https://github.com/Bouni/swisshydrodata/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
