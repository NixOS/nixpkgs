{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  isPy3k,
}:

buildPythonPackage (finalAttrs: {
  pname = "versiontools";
  version = "1.9.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "versiontools";
    inherit (finalAttrs) version;
    hash = "sha256-qWkzKIehipyYsN8OpNTKdZcvJMqU8G+4fVkTd+g0FPY=";
  };

  build-system = [ setuptools ];

  doCheck = (!isPy3k);

  meta = {
    homepage = "https://launchpad.net/versiontools";
    description = "Smart replacement for plain tuple used in __version__";
    license = lib.licenses.lgpl2;
  };
})
