{
  buildPythonPackage,
  fetchPypi,
  isPy27,
  lib,
  setuptools,
  simpy,
  tkinter,
  # GUI-based visualization of the simulation is optional
  enableVisualization ? true,
}:

buildPythonPackage rec {
  pname = "wsnsimpy";
  version = "0.2.5";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IpKsJKQC5l1pvFaRemlZV7iMMlYgO+G4oyptwThu7qw=";
  };

  propagatedBuildInputs = [
    setuptools
    simpy
  ] ++ lib.optional enableVisualization tkinter;

  # No test cases are included, thus unittest tries to run the examples, which
  # fail because no DISPLAYs are available.
  doCheck = false;

  pythonImportsCheck = [ "wsnsimpy" ] ++ lib.optional enableVisualization "wsnsimpy.wsnsimpy_tk";

  meta = with lib; {
    description = "SimPy-based WSN Simulator";
    homepage = "https://pypi.org/project/wsnsimpy/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dmrauh ];
  };
}
