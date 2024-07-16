{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
  tabulate,
}:

buildPythonPackage rec {
  pname = "vtjp";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Miicroo";
    repo = "python-vasttrafik";
    rev = "refs/tags/v${version}";
    hash = "sha256-3/toHY2PkG87J5bIMNJZHF/4mUvWaeHamMzPa1St7Xo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    tabulate
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "vasttrafik" ];

  meta = with lib; {
    description = "Python wrapper and cli for Västtrafik public API";
    mainProgram = "vtjp";
    homepage = "https://github.com/Miicroo/python-vasttrafik";
    changelog = "https://github.com/Miicroo/python-vasttrafik/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
