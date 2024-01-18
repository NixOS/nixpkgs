{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waqiasync";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SOs998BQV4UlLnRB3Yf7zze51u43g2Npwgk6y80S+m8=";
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
