{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mitmproxy2swagger";
  version = "0.13.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alufers";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VHxqxee5sQWRS13V4SfY4LWaN0oxxWsNVDOEqUyKHfg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "ruamel.yaml"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    json-stream
    mitmproxy
    ruamel-yaml
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "mitmproxy2swagger"
  ];

  meta = with lib; {
    description = "Tool to automagically reverse-engineer REST APIs";
    mainProgram = "mitmproxy2swagger";
    homepage = "https://github.com/alufers/mitmproxy2swagger";
    changelog = "https://github.com/alufers/mitmproxy2swagger/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
