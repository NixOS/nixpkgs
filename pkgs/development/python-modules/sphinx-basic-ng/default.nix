{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-basic-ng";
<<<<<<< HEAD
  version = "1.0.0.beta2";
=======
  version = "1.0.0.beta1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-basic-ng";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-MHBGIKOKhGklrx3O075LRud8NhY2hzlTWh+jalrFpko=";
=======
    hash = "sha256-Zh9KvKs4js+AVSfIk0pAj6Kzq/O2m/MGTF+HCwYJTXk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    sphinx
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "sphinx_basic_ng" ];

  meta = with lib; {
    description = "A modernised skeleton for Sphinx themes";
    homepage = "https://sphinx-basic-ng.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
