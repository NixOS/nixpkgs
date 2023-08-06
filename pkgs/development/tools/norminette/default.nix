{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "norminette";
  version = "3.3.53";

  src = fetchFromGitHub {
    owner = "42School";
    repo = pname;
    rev = version;
    hash = "sha256-IvLy6ryu3Cwfl8XAV+Hyof6mjKDGQy17gYQFrQU5kXg=";
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
