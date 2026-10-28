{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vincenty";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maurycyp";
    repo = "vincenty";
    tag = finalAttrs.version;
    hash = "sha256-gzdaAtRjkhn0N/Dmk1tZc2GKRp1eveVbX+2G9cF+KNI=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "vincenty" ];

  meta = {
    description = "Calculate the geographical distance between 2 points with extreme accuracy";
    homepage = "https://github.com/maurycyp/vincenty";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
