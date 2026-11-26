{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cbor";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-EyJaJi3fVhXL2f1Vp2oNUwadGLB9Lp8Zw55qy4YJu7Y=";
  };

  build-system = [ setuptools ];

  # Tests are excluded from PyPI and four unit tests are also broken:
  # https://github.com/brianolson/cbor_py/issues/6
  doCheck = false;

  meta = {
    homepage = "https://github.com/brianolson/cbor_py";
    description = "Concise Binary Object Representation (CBOR) library";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
