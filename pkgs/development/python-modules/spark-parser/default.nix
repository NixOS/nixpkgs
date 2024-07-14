{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  click,
}:

buildPythonPackage rec {
  pname = "spark-parser";
  version = "1.8.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "spark_parser";
    inherit version;
    hash = "sha256-p7uXuXlT+4vwzYFY2CC2Rn7x5/dHc46CJIrkyCTx4lo=";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ click ];

  meta = with lib; {
    description = "Early-Algorithm Context-free grammar Parser";
    mainProgram = "spark-parser-coverage";
    homepage = "https://github.com/rocky/python-spark";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
  };
}
