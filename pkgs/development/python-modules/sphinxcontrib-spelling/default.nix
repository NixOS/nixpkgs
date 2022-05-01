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
  version = "7.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OBnRJinZXgyQkiT6QLRipn4K2zIdUCg9f8DRFobIrH4=";
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
