{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  setuptools,
}:
buildPythonPackage rec {
  pname = "unicodeit";
  version = "0.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "svenkreiss";
    repo = "unicodeit";
    rev = "refs/tags/v${version}";
    hash = "sha256-NeR3fGDbOzwyq85Sep9KuUiARCvefN6l5xcb8D/ntHE=";
  };

  build-system = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "unicodeit"
    "unicodeit.cli"
  ];

  meta = {
    description = "Converts LaTeX tags to unicode";
    homepage = "https://github.com/svenkreiss/unicodeit";
    licenses = with lib.licenses; [
      lppl13c
      mit
    ];
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
