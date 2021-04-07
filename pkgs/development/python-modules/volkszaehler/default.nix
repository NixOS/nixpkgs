{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "volkszaehler";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1oqzhC3Yq2V30F3ilr80vKFnTmI/CdIVLuzMlIr40xI=";
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
