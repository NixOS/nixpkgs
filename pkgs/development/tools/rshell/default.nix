{ lib, buildPythonApplication, fetchPypi, pyserial, pyudev }:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15pm60jfmr5nms43nrh5jlpz4lxxfhaahznfcys6nc4g80r2fwr2";
  };

  propagatedBuildInputs = [ pyserial pyudev ];

  meta = with lib; {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
