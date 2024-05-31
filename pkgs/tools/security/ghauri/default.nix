{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghauri";
  version = "1.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "r0oth3x49";
    repo = "ghauri";
    rev = "refs/tags/${version}";
    hash = "sha256-zd+Uf2t8yBWi07+BJYYYQ+4fIissuBdXjj877ul4gAQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    colorama
    requests
    tldextract
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghauri"
  ];

  meta = with lib; {
    description = "Tool for detecting and exploiting SQL injection security flaws";
    mainProgram = "ghauri";
    homepage = "https://github.com/r0oth3x49/ghauri";
    changelog = "https://github.com/r0oth3x49/ghauri/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
