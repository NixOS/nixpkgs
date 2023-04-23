{ lib, fetchPypi, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K4qRmrtefpKv41EnhguMJ2sqeXvv/OLayGFPmM/4byE=";
  };

  # Upstream doesn't run tests from setup.py
  doCheck = false;
  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    description = "Browser based viewer for profiling data";
    homepage = "https://jiffyclub.github.io/snakeviz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
