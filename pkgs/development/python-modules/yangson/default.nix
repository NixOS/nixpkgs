{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
<<<<<<< HEAD
, elementpath
=======
, pyxb
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yangson";
<<<<<<< HEAD
  version = "1.4.18";
=======
  version = "1.4.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-VMgx2MTiOoAw8tW8SckheN950JVbdWWSS3PWDNs0dT0=";
=======
    hash = "sha256-P447JnQ8zhalcg9k8prW1QQE3h5PqY155hFtvLvBVSI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    elementpath
=======
    pyxb
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yangson"
  ];

  meta = with lib; {
    description = "Library for working with data modelled in YANG";
    homepage = "https://github.com/CZ-NIC/yangson";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with maintainers; [ hexa ];
  };
}
