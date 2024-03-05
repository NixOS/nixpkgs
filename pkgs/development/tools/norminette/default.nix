{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "norminette";
  version = "3.3.55";

  src = fetchFromGitHub {
    owner = "42School";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-SaXOUpYEbc2QhZ8aKS+JeJ22MSXZ8HZuRmVQ9fWk7tM=";
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
