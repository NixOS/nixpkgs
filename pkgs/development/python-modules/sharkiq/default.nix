{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "sharkiq";
  version = "0.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5efb0ad13a66cf6a097da5c128347ef7bd0b2abe53a8ca65cbc847ec1190c8b";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sharkiq" ];

  meta = with lib; {
    description = "Python API for Shark IQ robots";
    homepage = "https://github.com/JeffResc/sharkiq";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
