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
  version = "7.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a11799366f02fbd3390abf6aa2d4f0fe34df9be6e5ac0b1c8139dbd6c7fb0c99";
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
