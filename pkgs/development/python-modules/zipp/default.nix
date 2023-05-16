{ lib
, buildPythonPackage
, fetchPypi
, func-timeout
<<<<<<< HEAD
, jaraco-itertools
=======
, jaraco_itertools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, setuptools-scm
}:

let zipp = buildPythonPackage rec {
  pname = "zipp";
<<<<<<< HEAD
  version = "3.16.2";
=======
  version = "3.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-68FZRqp4vWNFiZL8gew7b3sektUcNebeHDgE5zt5kUc=";
=======
    hash = "sha256-ESkprWSdqUHCPeUPNWorVXDJVLZRUGQrzN1mvxlNIks=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Prevent infinite recursion with pytest
  doCheck = false;

  nativeCheckInputs = [
    func-timeout
<<<<<<< HEAD
    jaraco-itertools
=======
    jaraco_itertools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "zipp"
  ];

  passthru.tests = {
    check = zipp.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = "https://github.com/jaraco/zipp";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}; in zipp
