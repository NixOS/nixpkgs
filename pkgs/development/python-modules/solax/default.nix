{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytest-cov
, pytest-httpserver
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
, voluptuous
}:

buildPythonPackage rec {
  pname = "solax";
<<<<<<< HEAD
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7UDTG8rw9XJd5LPqcAe2XyE7DQa96dBj9YOcgW+/aFc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];
=======
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lqzFY2Rfmc/9KUuFfq07DZkIIS2cJ1JqZ/8gP3+pu5U=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ aiohttp voluptuous ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov
    pytest-httpserver
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "solax"
  ];
=======
  pythonImportsCheck = [ "solax" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python wrapper for the Solax Inverter API";
    homepage = "https://github.com/squishykid/solax";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
