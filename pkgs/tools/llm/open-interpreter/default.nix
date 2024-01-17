{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "open-interpreter";
  version = "0.2.0";
  pyproject = true;

  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XeJ6cADtyXtqoTXwYJu+i9d3NYbJCLpYOeZYmdImtwI=";
  };

  # Remove unused dependency
  postPatch = ''
    substituteInPlace pyproject.toml --replace 'git-python = "^1.0.3"' ""
  '';

  pythonRelaxDeps = [
    "tiktoken"
  ];

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    python3.pkgs.pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    astor
    inquirer
    litellm
    pyyaml
    rich
    six
    tiktoken
    tokentrim
    wget
    psutil
    html2image
    ipykernel
    jupyter-client
    matplotlib
    toml
    posthog
    openai

    # Not explicitly in pyproject.toml but required due to use of `pkgs_resources`
    setuptools
  ];

  pythonImportsCheck = [ "interpreter" ];

  # Most tests required network access
  doCheck = false;

  meta = with lib; {
    description = "OpenAI's Code Interpreter in your terminal, running locally";
    homepage = "https://github.com/KillianLucas/open-interpreter";
    license = licenses.mit;
    changelog = "https://github.com/KillianLucas/open-interpreter/releases/tag/v${version}";
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "interpreter";
  };
}
