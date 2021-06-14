{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "twinkly-client";
  version = "0.0.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16jbm4ya4yk2nfswza1kpgks70rmy5lpsv9dv3hdjdnr1j44hr3i";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "twinkly_client" ];

  meta = with lib; {
    description = "Python module to communicate with Twinkly LED strings";
    homepage = "https://github.com/dr1rrb/py-twinkly-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
