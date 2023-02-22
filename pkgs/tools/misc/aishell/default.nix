{ lib
, fetchFromGitHub
, poetry-core
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aishell";
  version = "2023.02.21";

  src = fetchFromGitHub {
    owner = "code-yeongyu";
    repo = "AiShell";
    rev = "89c945077373bc8e916ef542fdf936853ca4e9a6";
    sha256 = "WesxMcxhD/uiIEj1UHOTbgF5gnvyG2DJtm8JRE/GDR0=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    python3
    poetry
    revchatgpt
    typer
    openai
    pydantic
    pyright
  ];

  checkInputs = with python3.pkgs; [
    pytest
    pytest-cov
  ];

  doCheck = false;

  meta = with lib; {
    description = "A simple Python code that connects to OpenAI's ChatGPT and executes the returned results";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/code-yeongyu/AiShell";
  };
}
