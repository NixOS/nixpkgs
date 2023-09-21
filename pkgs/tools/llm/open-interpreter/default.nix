{ lib
, python3
, fetchFromGitHub
}:
let
  version = "0.1.3";
in
python3.pkgs.buildPythonApplication {
  pname = "open-interpreter";
  format = "pyproject";
  inherit version;

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = "open-interpreter";
    rev = "v${version}";
    hash = "sha256-xmmyDIshEYql41k/7gF+ay7s3mI+iGCjr5gDfLkqLU0=";
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
    litellm
    openai
    # pyreadline3 # this is a windows deps
    python-dotenv
    rich
    six
    tiktoken
    tokentrim
    wget
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
  };
}
