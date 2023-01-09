{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "oscclip";
  version = "0.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rumpelsepp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WQvZn+SWamEqEXPutIZVDZTIczybtHUG9QsN8XxUeg8=";
  };

  disabled = python3.pkgs.pythonOlder "3.10";

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  pythonImportsCheck = [
    "oscclip"
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "Utilities to access the clipboard via OSC52";
    homepage = "https://github.com/rumpelsepp/oscclip";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ rumpelsepp ];
  };
}
