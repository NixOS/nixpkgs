{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "swisshydrodata";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1adpy6k2bknffzl5rckqpvaqyrvc00d6a4a4541438dqasx61npl";
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
