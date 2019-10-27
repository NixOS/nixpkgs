{ stdenv, fetchPypi, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11a8cd4g98vq2x61i99ncl5w83clnndwg909ya4y1cdf0k1ckb40";
  };

  # Upstream doesn't run tests from setup.py
  doCheck = false;
  propagatedBuildInputs = [ tornado ];

  meta = with stdenv.lib; {
    description = "Browser based viewer for profiling data";
    homepage = https://jiffyclub.github.io/snakeviz;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
