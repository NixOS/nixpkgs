{ lib, buildPythonApplication, fetchPypi, pyserial, pyudev }:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12gh9l13lwnlp330jl3afy3wgfkpjvdxr43flrg9k9kyyhbr191g";
  };

  propagatedBuildInputs = [ pyserial pyudev ];

  meta = with lib; {
    homepage = https://github.com/dhylands/rshell;
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
