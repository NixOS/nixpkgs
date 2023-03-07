{ buildPythonApplication, fetchPypi, poetry-core, python3, lib }:

buildPythonApplication rec {
  pname = "aishell";
  version = "2023.02.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "WesxMcxhD/uiIEj1UHOTbgF5gnvyG2DJtm8JRE/GDR0=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    python3
    poetry-core
    revchatgpt
    typer
    openai
    pydantic
    #    pyright
  ];

  checkInputs = with python3.pkgs; [
    pytest
    pytest-cov
  ];

  doCheck = false;

  meta = with lib; {
    description = "A simple Python code that connects to OpenAI's ChatGPT and executes the returned results";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/code-yeongyu/AiShell";
  };
}
