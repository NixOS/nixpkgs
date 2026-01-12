{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ipython,
  pytestCheckHook,
  requests,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jiffyclub";
    repo = "snakeviz";
    tag = "v${version}";
    hash = "sha256-s/OATRnkooucRkLer5A66X9xDEA7aKNo+c10m1N7Guw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ tornado ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    ipython
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "snakeviz" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
    export HOME="$PWD/.home"
    mkdir -p "$HOME"
  '';

  meta = {
    description = "Browser based viewer for profiling data";
    mainProgram = "snakeviz";
    homepage = "https://jiffyclub.github.io/snakeviz";
    changelog = "https://github.com/jiffyclub/snakeviz/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      nixy
      pbsds
    ];
  };
}
