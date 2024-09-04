{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  click,
}:

buildPythonPackage rec {
  pname = "spark-parser";
  version = "1.8.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "spark_parser";
    inherit version;
    sha256 = "0np2y4jcir4a4j18wws7yzkz2zj6nqhdhn41rpq8pyskg6wrgfx7";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "test"
    "-v"
  ];

  meta = with lib; {
    description = "Early-Algorithm Context-free grammar Parser";
    mainProgram = "spark-parser-coverage";
    homepage = "https://github.com/rocky/python-spark";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
  };
}
