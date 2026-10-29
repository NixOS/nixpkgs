{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-psycopg2";
  version = "2.9.21.20260724";
  pyproject = true;

  src = fetchPypi {
    pname = "types_psycopg2";
    inherit (finalAttrs) version;
    hash = "sha256-2zEDHDfegjorIceHy4SDIXT92iqZqLGvZIIG8ZzDL4w=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "psycopg2-stubs" ];

  doCheck = false;

  meta = {
    description = "Typing stubs for psycopg2";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
