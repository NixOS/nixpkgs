{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yuakUmtDS2QoFrNKAOEYbVpfXgyUirlNKpGOAeWHQGY=";
  };

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [ "voluptuous" ];

  meta = with lib; {
    description = "Python data validation library";
    homepage = "http://alecthomas.github.io/voluptuous/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
