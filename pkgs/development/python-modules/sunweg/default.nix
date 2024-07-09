{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sunweg";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rokam";
    repo = "sunweg";
    rev = "refs/tags/${version}";
    hash = "sha256-9VzDOl393+jm6Nf40X4ZPMBbRc6KOwOQkpTNoqBsw1M=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sunweg" ];

  meta = with lib; {
    description = "Module to access the WEG solar energy platform";
    homepage = "https://github.com/rokam/sunweg";
    changelog = "https://github.com/rokam/sunweg/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
