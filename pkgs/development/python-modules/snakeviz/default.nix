{ stdenv, fetchPypi, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fe23667708a4ed04047abfbf209675a8488ea6ea8c038d7de06d8a083fb3531";
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
