{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sunweg";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rokam";
    repo = "sunweg";
    rev = "refs/tags/${version}";
    hash = "sha256-/pniECgavRiQdKzNtPINNhOijUW/uhPEOQJtjfr46ps=";
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
