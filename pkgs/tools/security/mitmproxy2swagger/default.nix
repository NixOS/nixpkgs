{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mitmproxy2swagger";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alufers";
    repo = "mitmproxy2swagger";
    rev = "refs/tags/${version}";
    hash = "sha256-VHxqxee5sQWRS13V4SfY4LWaN0oxxWsNVDOEqUyKHfg=";
  };

  pythonRelaxDeps = [
    "mitmproxy"
    "ruamel.yaml"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    json-stream
    mitmproxy
    ruamel-yaml
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy2swagger" ];

  meta = with lib; {
    description = "Tool to automagically reverse-engineer REST APIs";
    homepage = "https://github.com/alufers/mitmproxy2swagger";
    changelog = "https://github.com/alufers/mitmproxy2swagger/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "mitmproxy2swagger";
  };
}
