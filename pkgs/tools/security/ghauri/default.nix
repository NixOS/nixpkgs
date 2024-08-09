{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghauri";
  version = "1.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "r0oth3x49";
    repo = "ghauri";
    rev = "refs/tags/${version}";
    hash = "sha256-ea0YJuHT4G6Y9AE9sZEHTa/Ljtw2fATFha/j4VmukcA=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
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
    homepage = "https://github.com/r0oth3x49/ghauri";
    changelog = "https://github.com/r0oth3x49/ghauri/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ghauri";
  };
}
