{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-newsfeed";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d7gam3mn8v4in4p16yn3v10vps7nnaz6ilw99j4klij39dqd37p";
  };

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "Extension for adding a simple Blog, News or Announcements section to a Sphinx website";
    homepage = "https://bitbucket.org/prometheus/sphinxcontrib-newsfeed";
    license = licenses.bsd2;
  };

}
