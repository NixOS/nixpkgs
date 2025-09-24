{
  # Basic
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Build system
  setuptools,
  # Dependencies
  click,
  deprecated,
  networkx,
  tabulate,
  # Test
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tsplib95";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhgrant10";
    repo = "tsplib95";
    tag = "v${version}";
    hash = "sha256-rDKnfuauA9+mlgL6Prfz0uRP2rWxiQruXBj422/6Eak=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    deprecated
    networkx
    tabulate
  ];

  # Remove deprecated pytest-runner
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  pythonRelaxDeps = [
    "networkx"
    "tabulate"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tsplib95" ];

  meta = {
    description = "Library for working with TSPLIB 95 files";
    homepage = "https://github.com/rhgrant10/tsplib95";
    mainProgram = "tsplib95";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thattemperature ];
  };
}
