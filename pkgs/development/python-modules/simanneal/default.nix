{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "simanneal";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "perrygeo";
    repo = "simanneal";
    rev = version;
    hash = "sha256-yKZHkrf6fM0WsHczIEK5Kxusz5dSBgydK3fLu1nDyvk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];
  checkPhase = "pytest tests";

  meta = {
    description = "Python implementation of the simulated annealing optimization technique";
    homepage = "https://github.com/perrygeo/simanneal";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
