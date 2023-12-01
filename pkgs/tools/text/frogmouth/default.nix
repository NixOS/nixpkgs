{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "frogmouth";
  version = "0.9.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "frogmouth";
    rev = "v${version}";
    hash = "sha256-0fcCON/M9JklE7X9aRfzTkEFG4ckJqLoQlYCSrWHHGQ=";
  };

  # Per <https://github.com/srstevenson/xdg-base-dirs/tree/6.0.0#xdg-base-dirs>, the package is
  # renamed from `xdg` to `xdg_base_dirs`, but upstream isn't amenable to performing that rename.
  # See <https://github.com/Textualize/frogmouth/pull/59>. So this is a minimal fix.
  postUnpack = ''
    sed -i -e "s,from xdg import,from xdg_base_dirs import," $sourceRoot/frogmouth/data/{config,data_directory}.py
  '';

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    python3.pkgs.pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    httpx
    textual
    typing-extensions
    xdg-base-dirs
  ];

  pythonRelaxDeps = [
    "httpx"
    "textual"
    "xdg-base-dirs"
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
