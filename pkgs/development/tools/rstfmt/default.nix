{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rstfmt";
  version = "0.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dzhu";
    repo = "rstfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-zvmKgNzfxyWYHoaD+q84I48r1Mpp4kU4oIGAwMSRRlA=";
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
