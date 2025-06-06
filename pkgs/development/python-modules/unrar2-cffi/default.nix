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
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "unrar2_cffi";
    hash = "sha256-P+MXSmoMiIkk42MEYoJq9Okd1JTVwEPLCjGGXrnpyDM=";
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

  preCheck = ''
    rm -r unrar
  '';

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
