{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "0.9.6";
  src = fetchPypi {
    inherit pname version;
    sha256 = "848fdb9ee5f30cf93b9f0d840db6e7562633d20abf7d67c2382a0a2162a79410";
  };
  meta = {
    homepage = https://github.com/danthedeckie/simpleeval;
    description = "A simple, safe single expression evaluator library";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
