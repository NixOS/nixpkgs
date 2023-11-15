{ lib
, python3
, fetchFromGitHub
, semgrep
}:
let
  version = "0.1.11";
in
python3.pkgs.buildPythonApplication {
  pname = "open-interpreter";
  format = "pyproject";
  inherit version;

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = "open-interpreter";
    rev = "v${version}";
    hash = "sha256-viUMGUBy5UNWag6P8tXE4TcJIx53Q/tASNV3bmCCK0g=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    astor
    gitpython
    huggingface-hub
    inquirer
    jinja2
    litellm
    openai
    # pyreadline3 # this is a windows deps
    python-dotenv
    pyyaml
    rich
    six
    tiktoken
    tokenizers
    tokentrim
    wget
    yaspin
  ] ++ [
    semgrep
  ];

  # the import check phase fails trying to do a network request to openai
  # because of litellm
  # pythonImportsCheck = [ "interpreter" ];

  meta = with lib; {
    description = "OpenAI's Code Interpreter in your terminal, running locally";
    homepage = "https://github.com/KillianLucas/open-interpreter";
    license = licenses.mit;
    changelog = "https://github.com/KillianLucas/open-interpreter/releases/tag/v${version}";
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "interpreter";
  };
}
