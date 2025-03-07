{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "teamcity-messages";
  version = "1.33";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-BAwAfe54J+gbbiz03Yiu3eC/9RnI7P0mfR3nfM1oKZw=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/unit-tests/" ];

  pythonImportsCheck = [ "teamcity" ];

  meta = with lib; {
    description = "Python unit test reporting to TeamCity";
    homepage = "https://github.com/JetBrains/teamcity-messages";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
