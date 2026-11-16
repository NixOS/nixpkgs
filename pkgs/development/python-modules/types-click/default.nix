{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  pname = "types-click";
  version = "7.1.8";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tmBJaL5kAdxRYxHKUHCKCii6p6DLhA79dBLw27/04JI=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = {
    description = "Collection of library stubs for Python, with static types";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfvillablanca ];
  };
}
