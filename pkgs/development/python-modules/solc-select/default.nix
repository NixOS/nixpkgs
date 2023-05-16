{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pycryptodome
}:

buildPythonPackage rec {
  pname = "solc-select";
<<<<<<< HEAD
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-23ud4AmvbeOlQWuAu+W21ja/MUcDwBYxm4wSMeJIpsc=";
=======
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-850IA1NVvQ4KiH5KEIjqEKFd1k5ECMx/zXLZE7Rvx5k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    packaging
    pycryptodome
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "solc_select" ];

  meta = with lib; {
    description = "Manage and switch between Solidity compiler versions";
    homepage = "https://github.com/crytic/solc-select";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ arturcygan ];
  };
}
