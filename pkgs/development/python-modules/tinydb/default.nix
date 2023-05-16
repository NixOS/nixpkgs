{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pycodestyle
, pyyaml
}:

buildPythonPackage rec {
  pname = "tinydb";
<<<<<<< HEAD
  version = "4.8.0";
=======
  version = "4.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-sdWcpkjC8LtOI1k0Wyk4vLXBcwYe1vuQON9J7P8JPxA=";
=======
    hash = "sha256-nKsTMakCOBVHDDp8AX/xDkvHpCMBoIb0pa24F4VX/14=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov-append --cov-report term --cov tinydb" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pycodestyle
    pyyaml
  ];

  pythonImportsCheck = [ "tinydb" ];

  meta = with lib; {
    description = "Lightweight document oriented database written in Python";
    homepage = "https://tinydb.readthedocs.org/";
    changelog = "https://tinydb.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ marcus7070 ];
  };
}
