{ lib, buildPythonPackage, PyStemmer, fetchPypi }:

buildPythonPackage rec {
  pname = "snowballstemmer";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e997baa4f2e9139951b6f4c631bad912dfd3c792467e2f03d7239464af90e914";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [ PyStemmer ];

  meta = with lib; {
    description = "16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms";
    homepage = "http://sigal.saimon.org/en/latest/index.html";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
