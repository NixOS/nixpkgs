{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mitmproxy2swagger";
  version = "0.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alufers";
    repo = pname;
    rev = version;
    hash = "sha256-NTxRq7lIm3Y5RxOxdXiKVv39Co8GG9YE2kuEryRUw1Y=";
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
