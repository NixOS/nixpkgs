{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "simpy";
  version = "3.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd8c16ca3cff1574c99fe9f5ea4019c631c327f2bdc842e8b1a5c55f5e3e9d27";
  };

  meta = with lib; {
    homepage = "https://simpy.readthedocs.io/en/latest/";
    description = "A process-based discrete-event simulation framework based on standard Python.";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ shlevy ];
  };
}
