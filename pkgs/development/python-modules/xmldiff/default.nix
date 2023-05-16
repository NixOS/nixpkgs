{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, lxml
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xmldiff";
<<<<<<< HEAD
  version = "2.6.3";
=======
  version = "2.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-GbAws/o30fC1xa2a2pBZiEw78sdRxd2PHrTtSc/j/GA=";
=======
    hash = "sha256-gbgX7y/Q3pswM2tH/R1GSMmbMGhQJKB7w08sFGQE4Vk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    lxml
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xmldiff"
  ];

  meta = with lib; {
    description = "Creates diffs of XML files";
    homepage = "https://github.com/Shoobx/xmldiff";
    changelog = "https://github.com/Shoobx/xmldiff/blob/master/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
