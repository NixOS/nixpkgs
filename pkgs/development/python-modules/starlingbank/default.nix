{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "starlingbank";
  version = "3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pqWnRyCAc50KQmbqYq9Mje+PWXCFmTAjs8jA13YM0nA=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "starlingbank" ];

  meta = {
    description = "An unofficial python package that provides access to parts of the Starling bank API";
    homepage = "https://github.com/Dullage/starlingbank";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
