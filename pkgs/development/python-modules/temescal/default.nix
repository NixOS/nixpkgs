{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pycryptodome,
}:

buildPythonPackage (finalAttrs: {
  pname = "temescal";
  version = "0.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "temescal";
    inherit (finalAttrs) version;
    hash = "sha256-MfTftheNj8zI3iXIIJU+jy9xikvX9eO58LA0NCMJBnY=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodome ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "temescal" ];

  meta = {
    description = "Module for interacting with LG speaker systems";
    homepage = "https://github.com/google/python-temescal";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
