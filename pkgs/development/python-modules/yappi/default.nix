{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gs48c5sy771lsjhca3m4j8ljc6yhk5qnim3n5idnlaxa4ql30bz";
  };

  patches = [ ./tests.patch ];

  checkInputs = [ nose ];

  meta = with lib; {
    homepage = https://github.com/sumerc/yappi;
    description = "Python profiler that supports multithreading and measuring CPU time";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
  };
}
