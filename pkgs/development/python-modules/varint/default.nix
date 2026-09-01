{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "varint";
  version = "1.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "varint";
    inherit (finalAttrs) version;
    hash = "sha256-puzAI3esXunWWmqK1Fyf8drIzO4ZQApZUPtR1ZQhTKU=";
  };

  build-system = [ setuptools ];

  # No tests are available
  doCheck = false;

  pythonImportsCheck = [ "varint" ];

  meta = {
    description = "Basic varint implementation in python";
    homepage = "https://github.com/fmoo/python-varint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
})
