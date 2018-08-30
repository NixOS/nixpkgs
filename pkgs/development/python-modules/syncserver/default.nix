{ buildPythonPackage
, fetchgit
, isPy27
, unittest2
, cornice
, gunicorn
, pyramid
, requests
, simplejson
, sqlalchemy
, mozsvc
, tokenserver
, serversyncstorage
, configparser
}:

buildPythonPackage rec {
  pname = "syncserver";
  version = "1.6.0";
  disabled = ! isPy27;

  src = fetchgit {
    url = https://github.com/mozilla-services/syncserver.git;
    rev = "refs/tags/${version}";
    sha256 = "1fsiwihgq3z5b5kmssxxil5g2abfvsf6wfikzyvi4sy8hnym77mb";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [
    cornice gunicorn pyramid requests simplejson sqlalchemy mozsvc tokenserver
    serversyncstorage configparser
  ];
}
