{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "teamcity-messages";
  version = "1.33";
  pyproject = true;

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

  meta = {
    description = "Python unit test reporting to TeamCity";
    homepage = "https://github.com/JetBrains/teamcity-messages";
    changelog = "https://github.com/JetBrains/teamcity-messages/releases/tag/v${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
