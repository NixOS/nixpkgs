{
  buildPythonPackage,
  cffi,
  fetchPypi,
  lib,
  nix-update-script,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "unrar2-cffi";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "unrar2_cffi";
    hash = "sha256-z8jOntg/d9c/ogtgkum5AXt7oKCFYj8ggvQNTZtp724=";
  };

  build-system = [
    cffi
    setuptools
  ];

  dependencies = [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests fail with: ModuleNotFoundError: No module named 'unrar.cffi._unrarlib'
  doCheck = false;

  pythonImportsCheck = [
    "unrar.cffi"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Read RAR file from python -- cffi edition";
    homepage = "https://github.com/noaione/unrar2-cffi";
    changelog = "https://github.com/noaione/unrar2-cffi/releases/tag/v${version}";
    license = with lib; [
      licenses.asl20
      licenses.unfreeRedistributable # for including unrar
    ];
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
