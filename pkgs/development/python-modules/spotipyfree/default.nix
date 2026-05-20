{
  buildPythonPackage,
  fetchPypi,
  lib,
  pymongo,
  setuptools,
  spotapi,
}:

buildPythonPackage (finalAttrs: {
  pname = "spotipyfree";
  version = "1.5.0";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-MwqdvhpMWjGlH8mB2yGUWPghNLllUcbZ6jZjpftpYRk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pymongo
    spotapi
  ];

  pythonImportsCheck = [ "SpotipyFree" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Spotipy-compatible wrapper using SpotAPI";
    homepage = "https://github.com/TzurSoffer/spotipyFree";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
