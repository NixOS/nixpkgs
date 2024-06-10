{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  poetry-core,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "single-source";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rabbit72";
    repo = "single-source";
    rev = "refs/tags/v${version}";
    hash = "sha256-bhfMRIeJUd5JhN2tPww7fdbmHQ7ypcsZrYSa55v0+W8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ importlib-metadata ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "single_source" ];

  meta = with lib; {
    description = "Access to the project version in Python code for PEP 621-style projects";
    homepage = "https://github.com/rabbit72/single-source";
    changelog = "https://github.com/rabbit72/single-source/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
