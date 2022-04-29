{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "sharkiqpy";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nk1nbplyk28qadxc7rydjvdgbz3za0xjg6c95l95mhiz453q5sw";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "sharkiqpy" ];

  meta = with lib; {
    description = "Python API for Shark IQ robot";
    homepage = "https://github.com/ajmarks/sharkiq";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
