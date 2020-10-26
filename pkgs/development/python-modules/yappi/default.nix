{ lib, buildPythonPackage, fetchPypi, isPy27, nose }:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.2.5";
  disabled = isPy27; # invalid syntax

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad5fa4caf2859e480ffc4ec3e85615a6f7dea852c8f035f2db723f824ed4ba11";
  };

  patches = [ ./tests.patch ];

  checkInputs = [ nose ];

  meta = with lib; {
    broken = true;
    homepage = "https://github.com/sumerc/yappi";
    description = "Python profiler that supports multithreading and measuring CPU time";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
  };
}
