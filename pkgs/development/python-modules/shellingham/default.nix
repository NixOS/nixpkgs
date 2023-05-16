{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "shellingham";
<<<<<<< HEAD
  version = "1.5.1";
  format = "pyproject";

=======
  version = "1.5.0.post1";
  format = "pyproject";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-7hMlKw9oSGp57FQmbxdAgUsm5cFRr1oTW1ymJyYsgOg=";
=======
    hash = "sha256-nAXI1GxSpmmpJuatPYUeAClA88B9c/buPEWhq7RKvs8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "shellingham"
  ];
=======
  pythonImportsCheck = [ "shellingham" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to detect the surrounding shell";
    homepage = "https://github.com/sarugaku/shellingham";
<<<<<<< HEAD
    changelog = "https://github.com/sarugaku/shellingham/blob/${version}/CHANGELOG.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
