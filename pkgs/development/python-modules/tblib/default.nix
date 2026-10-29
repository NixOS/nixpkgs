{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "tblib";
  version = "3.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-6aZSaS2Rv090PUoVvBdMC3avx1D+jHttGVzBwdbSzOw=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = {
    description = "Traceback fiddling library. Allows you to pickle tracebacks";
    homepage = "https://github.com/ionelmc/python-tblib";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ teh ];
  };
})
