{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "waqiasync";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SOs998BQV4UlLnRB3Yf7zze51u43g2Npwgk6y80S+m8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "waqiasync" ];

  meta = {
    description = "Python library for http://aqicn.org";
    homepage = "https://github.com/andrey-git/waqi-async";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
