{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.9.0.20240106";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ybbbEN1/z1W9FxLdNTf4bdznKgj9Yrsa9DOMcJbOlH4=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "tabulate-stubs" ];

  meta = {
    description = "Typing stubs for tabulate";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
