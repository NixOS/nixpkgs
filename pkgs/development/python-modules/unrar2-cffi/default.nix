{
  buildPythonPackage,
  cffi,
  fetchPypi,
  fetchurl,
  lib,
  nix-update-script,
  pytest,
  pythonOlder,
  setuptools,
}:
let
  # Fetch the RAR test files which are missing from the PyPI archive
  test_rar = fetchurl {
    url = "https://raw.githubusercontent.com/noaione/unrar2-cffi/v0.4.0/tests/test_rar.rar";
    sha256 = "sha256-2+pp6Pd8OSLrogLjYl3HcTtX1/6num+BieLok5p1QQk=";
  };
  test_no_cmt = fetchurl {
    url = "https://raw.githubusercontent.com//noaione/unrar2-cffi/v0.4.0/tests/test_no_cmt.rar";
    sha256 = "sha256-qCPsyPJqR+S84KWGzpMpvCfuVQLiWlOBePyD/k8reDM=";
  };
  test_corrupted = fetchurl {
    url = "https://raw.githubusercontent.com//noaione/unrar2-cffi/v0.4.0/tests/test_corrupted.rar";
    sha256 = "sha256-1gdvFo/2CBbaqnuhTlBexowdD/2GXDvq5kDXSIvMJDU=";
  };
  test_rar_pwd = fetchurl {
    url = "https://raw.githubusercontent.com/noaione/unrar2-cffi/v0.4.0/tests/test_rar_pwd.rar";
    sha256 = "sha256-UoXygL1dg5PnUsl/DFdBH6zZAmgK+OWcNdXb9bflrDo=";
  };
in
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

  patchPhase = ''
    cp ${test_rar} tests/test_rar.rar
    cp ${test_no_cmt} tests/test_no_cmt.rar
    cp ${test_corrupted} tests/test_corrupted.rar
    cp ${test_rar_pwd} tests/test_rar_pwd.rar
  '';

  build-system = [
    cffi
    setuptools
  ];

  dependencies = [
    cffi
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    runHook preCheck

    pytest

    runHook postCheck
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
