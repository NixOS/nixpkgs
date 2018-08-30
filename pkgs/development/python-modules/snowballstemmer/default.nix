{ stdenv, buildPythonPackage, PyStemmer, fetchPypi }:

buildPythonPackage rec {
  pname = "snowballstemmer";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128";
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
