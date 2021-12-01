{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TbGsUHnbkkmCDUnIkctGYKb4yuNQSRIQq850H6v1ZRM=";
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
