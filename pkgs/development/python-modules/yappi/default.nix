{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8db9bc607610d6da4e27e87ec828ebddec4bdaac89ca07ebfe9a153b0641580";
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
