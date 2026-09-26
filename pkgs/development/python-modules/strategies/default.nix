{
  lib,
  buildPythonPackage,
  fetchPypi,
  multipledispatch,
  toolz,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "strategies";
  version = "0.2.3";

  __structuredAttrs = true;
  pyproject = true;

  # GitHub upstream do not have proper release tags
  src = fetchPypi {
    pname = "strategies";
    inherit (finalAttrs) version;
    sha256 = "02i4ydrs9k61p8iv2vl2akks8p9gc88rw8031wlwb1zqsyjmb328";
  };

  build-system = [ setuptools ];

  dependencies = [
    multipledispatch
    toolz
  ];

  doCheck = false; # no tests in Pypi archive

  meta = {
    description = "Python library for control flow programming";
    homepage = "https://github.com/logpy/strategies";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ suhr ];
  };
})
