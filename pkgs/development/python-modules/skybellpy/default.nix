{
  lib,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  pytest-sugar,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "skybellpy";
  version = "0.6.3";
  pyproject = true;

  # Still uses distrutils, https://github.com/MisterWil/skybellpy/issues/22
  disabled = pythonOlder "3.6" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "MisterWil";
    repo = "skybellpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-/+9KYxXYTN0T6PoccAA/pwdwWqOzCSZdNxj6xi6oG74=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorlog
    requests
  ];

  nativeCheckInputs = [
    pytest-sugar
    pytest-timeout
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "skybellpy" ];

  meta = with lib; {
    description = "Python wrapper for the Skybell alarm API";
    homepage = "https://github.com/MisterWil/skybellpy";
    changelog = "https://github.com/MisterWil/skybellpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "skybellpy";
  };
}
