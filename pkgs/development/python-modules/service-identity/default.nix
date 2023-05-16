{ lib
, attrs
, buildPythonPackage
, cryptography
, fetchFromGitHub
<<<<<<< HEAD
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, idna
, pyasn1
, pyasn1-modules
, pytestCheckHook
, pythonOlder
=======
, idna
, pyasn1
, pyasn1-modules
, six
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "service-identity";
<<<<<<< HEAD
  version = "23.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "21.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-PGDtsDgRwh7GuuM4OuExiy8L4i3Foo+OD0wMrndPkvo=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

=======
    rev = version;
    hash = "sha256-pWc2rU3ULqEukMhd1ySY58lTm3s8f/ayQ7CY4nG24AQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    attrs
    cryptography
    idna
    pyasn1
    pyasn1-modules
<<<<<<< HEAD
=======
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "service_identity"
  ];
=======
  pythonImportsCheck = [ "service_identity" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Service identity verification for pyOpenSSL";
    homepage = "https://service-identity.readthedocs.io";
<<<<<<< HEAD
    changelog = "https://github.com/pyca/service-identity/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
