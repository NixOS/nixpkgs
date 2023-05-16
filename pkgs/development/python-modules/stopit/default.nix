{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, setuptools

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "stopit";
  version = "1.1.2";

  # tests are missing from the PyPi tarball
  src = fetchFromGitHub {
    owner = "glenfant";
    repo = pname;
    rev = version;
    hash = "sha256-uXJUA70JOGWT2NmS6S7fPrTWAJZ0mZ/hICahIUzjfbw=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
    setuptools # for pkg_resources
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "stopit" ];

  meta = with lib; {
    description = "Raise asynchronous exceptions in other thread, control the timeout of blocks or callables with a context manager or a decorator";
    homepage = "https://github.com/glenfant/stopit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
