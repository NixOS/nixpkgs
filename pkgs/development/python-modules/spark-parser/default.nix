{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  click,
}:

buildPythonPackage (finalAttrs: {
  pname = "spark-parser";
  version = "1.9.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "spark_parser";
    inherit (finalAttrs) version;
    hash = "sha256-3GbUjEJlxBM9tBqcX+nBxQKzsgFn3xWKDyNM0xcSz2Q=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ unittestCheckHook ];
  unittestFlags = [
    "--start-directory=test"
    "-v"
  ];

  meta = {
    description = "Early-Algorithm Context-free grammar Parser";
    mainProgram = "spark-parser-coverage";
    homepage = "https://github.com/rocky/python-spark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin ];
  };
})
