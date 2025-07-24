{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = "pandoc-include";
    tag = "v${version}";
    hash = "sha256-8ldIywvCExnbMNs9m7iLwM1HrTRHl7j4t3JQuBt0Z7U=";
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

  meta = with lib; {
    description = "Pandoc filter to allow file and header includes";
    homepage = "https://github.com/DCsunset/pandoc-include";
    license = licenses.mit;
    maintainers = with maintainers; [
      ppenguin
      DCsunset
    ];
    mainProgram = "pandoc-include";
  };
}
