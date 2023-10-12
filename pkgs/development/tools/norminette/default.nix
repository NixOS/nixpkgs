{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "norminette";
  version = "3.3.54";

  src = fetchFromGitHub {
    owner = "42School";
    repo = pname;
    rev = version;
    hash = "sha256-r7cFaETv2gxNRhfw/F3B+7r3JzwvFvIFVSQ6MHQuEi4=";
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
