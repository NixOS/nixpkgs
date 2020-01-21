{ stdenv, buildPythonPackage, PyStemmer, fetchPypi }:

buildPythonPackage rec {
  pname = "snowballstemmer";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df3bac3df4c2c01363f3dd2cfa78cce2840a79b9f1c2d2de9ce8d31683992f52";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [ PyStemmer ];

  meta = with stdenv.lib; {
    description = "16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms";
    homepage = http://sigal.saimon.org/en/latest/index.html;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
