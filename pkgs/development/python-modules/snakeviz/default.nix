{ lib, fetchPypi, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d96c006304f095cb4b3fb7ed98bb866ca35a7ca4ab9020bbc27d295ee4c94d9";
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
