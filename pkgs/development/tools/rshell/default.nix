{ lib, buildPythonApplication, fetchPypi, pyserial, pyudev }:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05nvfaykzwj1y86fcckrnvmrva7849lkbmpxsy2hb9akk0y7li6c";
  };

  propagatedBuildInputs = [ pyserial pyudev ];

  meta = with lib; {
    homepage = https://github.com/dhylands/rshell;
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
