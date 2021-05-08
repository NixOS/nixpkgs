{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wiffi";
  version = "1.0.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "python-wiffi";
    rev = version;
    sha256 = "1bsx8dcmbkajh7hdgxg6wdnyxz4bfnd45piiy3yzyvszfdyvxw0f";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "wiffi" ];

  meta = with lib; {
    description = "Python module to interface with STALL WIFFI devices";
    homepage = "https://github.com/mampfes/python-wiffi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
