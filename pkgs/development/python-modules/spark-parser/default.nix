{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  click,
}:

buildPythonPackage rec {
  pname = "spark-parser";
  version = "1.9.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "spark_parser";
    inherit version;
    sha256 = "sha256-3GbUjEJlxBM9tBqcX+nBxQKzsgFn3xWKDyNM0xcSz2Q=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "test"
    "-v"
  ];

  meta = {
    description = "Early-Algorithm Context-free grammar Parser";
    mainProgram = "spark-parser-coverage";
    homepage = "https://github.com/rocky/python-spark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
