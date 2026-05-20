{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
}:

buildPythonPackage {
  pname = "splines";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "splines";
    version = "0.3.3";
    hash = "sha256-nZEIMD8POw4b6OAUxKckxnSmwFWKsQHhTdBMdFBcTrk=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "splines" ];

  meta = {
    description = "Spline curves in Euclidean and rotation spaces";
    homepage = "https://github.com/AudioSceneDescriptionFormat/splines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
}
