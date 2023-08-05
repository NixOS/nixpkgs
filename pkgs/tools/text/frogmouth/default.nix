{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "frogmouth";
  version = "0.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "frogmouth";
    rev = "v${version}";
    hash = "sha256-GVXzYPYvqgWRFOZW+dfYVI6Dhk9yUmuJ7V8wtM0VjR0=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    python3.pkgs.pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    httpx
    textual
    typing-extensions
    xdg
  ];

  pythonRelaxDeps = [
    "httpx"
    "textual"
    "xdg"
  ];

  pythonImportsCheck = [ "frogmouth" ];

  meta = with lib; {
    description = "A Markdown browser for your terminal";
    homepage = "https://github.com/Textualize/frogmouth";
    changelog = "https://github.com/Textualize/frogmouth/blob/${src.rev}/ChangeLog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
