{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-shapely";
  version = "2.1.0.20260603";
  pyproject = true;

  src = fetchPypi {
    pname = "types_shapely";
    inherit version;
    hash = "sha256-A3PvccqowXr/C4ELgVX3RM6u7oAvbxQ40J3RyRlhIYA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "'shapely-stubs' = [" "'*' = [" \
      --replace-fail "setuptools>=82.0.1" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "shapely-stubs" ];

  meta = {
    description = "Typing stubs for shapely";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
