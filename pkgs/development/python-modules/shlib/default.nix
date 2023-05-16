{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, braceexpand
, inform
}:

buildPythonPackage rec {
  pname = "shlib";
<<<<<<< HEAD
  version = "1.6";
=======
  version = "1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "shlib";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-f2jJgpjybutCpYnIT+RihtoA1YlXdhTs+MvV8bViSMQ=";
=======
    rev = "v${version}";
    hash = "sha256-2fwRxa64QXKJuhYwt9Z4BxhTeq1iwbd/IznfxPUjeSM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonImportsCheck = [ "shlib" ];
  postPatch = ''
    patchShebangs .
  '';
  nativeCheckInputs = [
    pytestCheckHook
  ];
  propagatedBuildInputs = [
    braceexpand
    inform
  ];

  meta = with lib; {
    description = "shell library";
    homepage = "https://github.com/KenKundert/shlib";
    changelog = "https://github.com/KenKundert/shlib/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
