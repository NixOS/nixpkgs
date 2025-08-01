{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  pillow,
  python-pptx,
  typst,
}:

buildPythonPackage rec {
  pname = "touying";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "touying-typ";
    repo = "touying-exporter";
    tag = version;
    hash = "sha256-gcr3KS2Qm8CMA+8AeC0hbGi9Gjj5sMr6gJkuoZWUEGY=";
  };

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [
    "argparse"
  ];
  dependencies = [
    jinja2
    pillow
    python-pptx
    typst
  ];

  pythonImportsCheck = [ "touying" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Export presentation slides in various formats for Touying";
    changelog = "https://github.com/touying-typ/touying-exporter/releases/tag/${version}";
    homepage = "https://github.com/touying-typ/touying-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "touying";
  };
}
