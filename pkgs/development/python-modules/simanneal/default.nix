{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "simanneal";
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "perrygeo";
    repo = "simanneal";
    tag = finalAttrs.version;
    hash = "sha256-yKZHkrf6fM0WsHczIEK5Kxusz5dSBgydK3fLu1nDyvk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];
  checkPhase = "pytest tests";

  pythonImportsCheck = [ "simanneal" ];

  meta = {
    description = "Python implementation of the simulated annealing optimization technique";
    homepage = "https://github.com/perrygeo/simanneal";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
