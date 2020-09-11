{ stdenv, fetchPypi, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s6byw23hr2khqx2az36hpi52fk4v6bfm1bb7biaf0d2nrpqgbcj";
  };

  # Upstream doesn't run tests from setup.py
  doCheck = false;
  propagatedBuildInputs = [ tornado ];

  meta = with stdenv.lib; {
    description = "Browser based viewer for profiling data";
    homepage = "https://jiffyclub.github.io/snakeviz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
