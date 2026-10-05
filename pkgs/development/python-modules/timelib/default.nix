{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "timelib";
  version = "0.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0bInBlVxhuYFjaiLoPhYN0AbKuneFX9ZNT3JeNglGHo=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "timelib" ];

  meta = {
    description = "Parse english textual date descriptions";
    homepage = "https://github.com/pediapress/timelib/";
    license = lib.licenses.zlib;
  };
})
