{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "simpleeval";
  version = "0.9.8";
  src = fetchPypi {
    inherit pname version;
    sha256 = "00fzwbjg98lsnmfzmbgzg1k8q8iqbahcxjnnlhzhb44phrhcxql5";
  };
  meta = {
    homepage = https://github.com/danthedeckie/simpleeval;
    description = "A simple, safe single expression evaluator library";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
