{ stdenv, fetchPypi, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hvfc7c25cz6p3m3p3klm3njiysp7lkrs9sxm4p40spldl0jlfpa";
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
