{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "arsenal";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Orange-Cyberdefense";
    repo = "arsenal";
    rev = version;
    sha256 = "sha256-RZxGSrtEa3hAtowD2lUb9BgwpSWlYo90fU9nDvUfoAk=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    libtmux
    docutils
    pyperclip
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "arsenal"
  ];

  meta = with lib; {
    description = "Tool to generate commands for security and network tools";
    homepage = "https://github.com/Orange-Cyberdefense/arsenal";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "arsenal";
  };
}
