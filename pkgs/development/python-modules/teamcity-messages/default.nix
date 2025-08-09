{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "teamcity-messages";
  version = "1.33";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "teamcity-messages";
    tag = "v${version}";
    hash = "sha256-BAwAfe54J+gbbiz03Yiu3eC/9RnI7P0mfR3nfM1oKZw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/unit-tests/" ];

  pythonImportsCheck = [ "teamcity" ];

  meta = with lib; {
    description = "Python unit test reporting to TeamCity";
    homepage = "https://github.com/JetBrains/teamcity-messages";
    changelog = "https://github.com/JetBrains/teamcity-messages/releases/tag/v${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
