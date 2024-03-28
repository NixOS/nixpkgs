{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rstfmt";
  version = "0.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dzhu";
    repo = "rstfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-SJRA14CfoT8XMt3hMB7cLdmuLwsJnBSwhKkD1pJvQCI=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    black
    docutils
    sphinx
  ];

  # Project has no unittest just sample files
  doCheck = false;

  pythonImportsCheck = [
    "rstfmt"
  ];

  meta = with lib; {
    description = "A formatter for reStructuredText";
    homepage = "https://github.com/dzhu/rstfmt";
    changelog = "https://github.com/dzhu/rstfmt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
