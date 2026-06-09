{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = "pandoc-include";
    tag = "v${version}";
    hash = "sha256-M0frQGg2nHbgY53ejMdbXKLJjXQgx8aNUVxeDDIHdp4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  passthru.updateScript = nix-update-script { };

  propagatedBuildInputs = with python3Packages; [
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
