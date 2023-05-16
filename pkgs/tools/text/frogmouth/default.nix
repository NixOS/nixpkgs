{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "frogmouth";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "frogmouth";
    rev = "v${version}";
    hash = "sha256-5MNQ78zwjtenHDjy2g1rjiq4HvFie7uUSlMwZu6RmXg=";
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
