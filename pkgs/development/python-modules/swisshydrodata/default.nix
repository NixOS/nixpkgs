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
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = "swisshydrodata";
    tag = version;
    hash = "sha256-e3h/FStzhyaI//bRvT57lA6+06hVqhL2aztI115bsvU=";
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
