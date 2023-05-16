{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ultraheat-api";
<<<<<<< HEAD
  version = "0.5.7";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ultraheat_api";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-rRQTjV9hyUawMaXBgUx/d6pQjM8ffjcFJE2x08Cf4Gw=";
=======
    hash = "sha256-7yZATv0cgjRnvD9u34iZtsdsfEkdbAoVWJ19+HHlrzI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # Source is not tagged, only PyPI releases
  doCheck = false;

  pythonImportsCheck = [
    "ultraheat_api"
  ];

  meta = with lib; {
    description = "Module for working with data from Landis+Gyr Ultraheat heat meter unit";
    homepage = "https://github.com/vpathuis/uh50";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
