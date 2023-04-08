{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "subzerod";
  version = "1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/7g8Upj9Hb4m83JXLI3X2lqa9faCt42LVxh+V9WpI68=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "subzerod"
  ];

  meta = with lib; {
    description = "Python module to help with the enumeration of subdomains";
    homepage = "https://github.com/sanderfoobar/subzerod";
    license = with licenses; [ wtfpl ];
    maintainers = with maintainers; [ fab ];
  };
}
