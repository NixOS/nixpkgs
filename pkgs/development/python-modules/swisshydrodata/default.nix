{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "swisshydrodata";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z8divdpdrjllf6y19kdrv19m7aqkbyxz43ml3d7hgaa6mj91mg5";
  };

  propagatedBuildInputs = [ requests ];

  # Tests are not releases at the moment
  doCheck = false;
  pythonImportsCheck = [ "swisshydrodata" ];

  meta = with lib; {
    description = "Python client to get data from the Swiss federal Office for Environment FEON";
    homepage = "https://github.com/bouni/swisshydrodata";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
