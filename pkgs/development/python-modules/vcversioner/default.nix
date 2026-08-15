{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vcversioner";
  version = "2.16.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "vcversioner";
    inherit (finalAttrs) version;
    hash = "sha256-2uYMF6R5eB9EpAEHAYM/GCkUCx7szSWHYqdJdKoG4Zs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "vcversioner" ];

  meta = {
    description = "Take version numbers from version control";
    homepage = "https://github.com/habnabit/vcversioner";
    license = lib.licenses.isc;
  };
})
