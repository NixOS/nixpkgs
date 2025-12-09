{
  lib,
  buildPythonPackage,
  pystemmer,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "snowballstemmer";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bV7u7I6fhNTVa4R2krrPebwsjpDH+AykRE/4tvLlKJU=";
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
