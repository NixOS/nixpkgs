{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  toml,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "single-source";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rabbit72";
    repo = "single-source";
    rev = "refs/tags/v${version}";
    hash = "sha256-4l9ochlscQoWJVkYN8Iq2DsiU7qoOf7nUFYgBOebK/g=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    toml
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "single_source" ];

  meta = {
    description = "Access to the project version in Python code for PEP 621-style projects";
    homepage = "https://github.com/rabbit72/single-source";
    changelog = "https://github.com/rabbit72/single-source/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
