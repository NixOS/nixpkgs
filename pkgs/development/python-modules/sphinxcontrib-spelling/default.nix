{ stdenv
, lib
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
  version = "7.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b4240808a6d21eab9c49e69ad5ac0cb3efb03fe2e94763d23c860f85ec6a799";
  };

  propagatedBuildInputs = [ sphinx pyenchant pbr ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Sphinx spelling extension";
    homepage = "https://bitbucket.org/dhellmann/sphinxcontrib-spelling";
    maintainers = with maintainers; [ nand0p ];
    license = licenses.bsd2;
  };

}
