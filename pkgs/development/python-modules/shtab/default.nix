{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-timeout
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
, bashInteractive
}:

buildPythonPackage rec {
  pname = "shtab";
<<<<<<< HEAD
  version = "1.6.4";
  format = "pyproject";
=======
  version = "1.6.1";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-BMwi3a7CPq58G30XlkJdSfSP6oc6u2AuSPAwEExI9zM=";
=======
    hash = "sha256-5qjavFzwFH75SlTQxxhMoJjBRIjGz9oogdvSw9dkjz0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=shtab --cov-report=term-missing --cov-report=xml" ""
  '';

  nativeBuildInputs = [
    setuptools
=======
  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools-scm
  ];

  nativeCheckInputs = [
    bashInteractive
    pytest-timeout
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=shtab --cov-report=term-missing --cov-report=xml" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "shtab"
  ];

  meta = with lib; {
    description = "Module for shell tab completion of Python CLI applications";
    homepage = "https://docs.iterative.ai/shtab/";
    changelog = "https://github.com/iterative/shtab/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
