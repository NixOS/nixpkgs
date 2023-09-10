{ lib, buildPythonPackage, pystemmer, fetchPypi }:

buildPythonPackage rec {
  pname = "snowballstemmer";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [ pystemmer ];

  meta = with lib; {
    description = "16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms";
    homepage = "http://sigal.saimon.org/en/latest/index.html";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
