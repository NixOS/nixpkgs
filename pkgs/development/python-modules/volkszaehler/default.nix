{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "volkszaehler";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13zhxq08wn5y9yn6xbazfl0gxxysmirwpc26wcnr6jk2va1kpc4l";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "volkszaehler" ];

  meta = with lib; {
    description = "Python Wrapper for interacting with the Volkszahler API";
    homepage = "https://github.com/home-assistant-ecosystem/python-volkszaehler";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
