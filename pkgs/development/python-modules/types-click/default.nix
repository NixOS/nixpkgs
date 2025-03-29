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
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tmBJaL5kAdxRYxHKUHCKCii6p6DLhA79dBLw27/04JI=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "Collection of library stubs for Python, with static types";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
  };
}
