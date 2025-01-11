{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "75.8.0.20250110";
  pyproject = true;

  src = fetchPypi {
    pname = "types_setuptools";
    inherit version;
    hash = "sha256-lvfsi71uClTqGA1mrWiteh15VOcoGnEOot5141VUUnE=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
