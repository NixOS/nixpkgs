{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.20250801";
  pyproject = true;

  src = fetchPypi {
    pname = "types_colorama";
    inherit version;
    hash = "sha256-AlZdE9aJY9EiN9PzMPXs1iKjF597WxTufxYUYnDDV/U=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
