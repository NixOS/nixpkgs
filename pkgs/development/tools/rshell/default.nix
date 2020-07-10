{ lib, buildPythonApplication, fetchPypi, pyserial, pyudev }:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1crnlv0khplpibl9mj3flrgp877pnr1xz6hnnsi6hk3kfbc6p3nj";
  };

  propagatedBuildInputs = [ pyserial pyudev ];

  meta = with lib; {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
