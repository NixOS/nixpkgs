{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sunweg";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rokam";
    repo = "sunweg";
    tag = version;
    hash = "sha256-T67eH5WjS7J2pcNjq9psNmD4MwMfH+HRvk9llqI3FoQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sunweg" ];

  meta = {
    description = "Module to access the WEG solar energy platform";
    homepage = "https://github.com/rokam/sunweg";
    changelog = "https://github.com/rokam/sunweg/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
