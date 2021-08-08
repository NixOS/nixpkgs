{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "7.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2578653014931b32c8c30d1a9930d998ae053b0d8b7adfbea0eb95a63e7a737";
  };

  propagatedBuildInputs = [ sphinx pyenchant pbr ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Sphinx spelling extension";
    homepage = "https://bitbucket.org/dhellmann/sphinxcontrib-spelling";
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
  };

}
