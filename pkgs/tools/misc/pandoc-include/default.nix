{
  buildPythonApplication,
  fetchFromGitHub,
  lib,
  natsort,
  panflute,
  lxml,
  setuptools,
  nix-update-script,
}:

buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = "pandoc-include";
    tag = "v${version}";
    hash = "sha256-M0frQGg2nHbgY53ejMdbXKLJjXQgx8aNUVxeDDIHdp4=";
  };

  build-system = [
    setuptools
  ];

  passthru.updateScript = nix-update-script { };

  propagatedBuildInputs = [
    natsort
    panflute
    lxml
  ];

  pythonImportsCheck = [ "pandoc_include.main" ];

  meta = {
    description = "Pandoc filter to allow file and header includes";
    homepage = "https://github.com/DCsunset/pandoc-include";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ppenguin
      DCsunset
    ];
    mainProgram = "pandoc-include";
  };
}
