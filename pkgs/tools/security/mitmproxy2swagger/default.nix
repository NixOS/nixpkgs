{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mitmproxy2swagger";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alufers";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-tLLz3nGIzsE6bkHbMC+Cfevv7E/NNHxtYqCUwo/5yF4=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
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
    homepage = "https://github.com/alufers/mitmproxy2swagger";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
