{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "volkszaehler";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "087gw1k3f81lm859r0j65cjia8c2dcy4cx8c7s3mb5msb1csdh0x";
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
