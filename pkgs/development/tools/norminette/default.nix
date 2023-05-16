{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "norminette";
<<<<<<< HEAD
  version = "3.3.54";
=======
  version = "3.3.51";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "42School";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-r7cFaETv2gxNRhfw/F3B+7r3JzwvFvIFVSQ6MHQuEi4=";
=======
    hash = "sha256-JpWziUKZPOD+AwiYeHR7e0B9l3XKNNp+XQkZEvynKGY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  preCheck = ''
    export PYTHONPATH=norminette:$PYTHONPATH
  '';

  meta = with lib; {
    description = "Open source norminette to apply 42's norme to C files";
    homepage = "https://github.com/42School/norminette";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
