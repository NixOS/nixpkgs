{ lib, buildPythonApplication, fetchPypi, pyserial, pyudev }:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6857cdc3c53c8ce9ba7a560c2759c10b988f3d9fafde912d3fa4deecb4d4664";
  };

  propagatedBuildInputs = [ pyserial pyudev ];

  meta = with lib; {
    homepage = https://github.com/dhylands/rshell;
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
