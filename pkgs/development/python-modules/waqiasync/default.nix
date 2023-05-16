{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waqiasync";
<<<<<<< HEAD
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SOs998BQV4UlLnRB3Yf7zze51u43g2Npwgk6y80S+m8=";
=======
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yxls7ywfg954c3vxgnp98qa1b8dsq9b2fld11fb9sx1k4mjc29d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
