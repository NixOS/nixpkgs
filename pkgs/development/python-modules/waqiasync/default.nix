{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waqiasync";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yxls7ywfg954c3vxgnp98qa1b8dsq9b2fld11fb9sx1k4mjc29d";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "waqiasync" ];

  meta = with lib; {
    description = "Python library for http://aqicn.org";
    homepage = "https://github.com/andrey-git/waqi-async";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
