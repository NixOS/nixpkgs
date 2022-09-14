{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "sharkiq";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BGf7wjqB+ty/UQnTqEYzLkWuoikWA4kHPvth7h1F53I=";
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
