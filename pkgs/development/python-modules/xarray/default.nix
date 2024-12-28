{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  numpy,
  packaging,
  pandas,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "2024.10.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pydata";
    repo = "xarray";
    rev = "refs/tags/v${version}";
    hash = "sha256-s5MvHp2OkomD3xNYzj9oKlVLMgHZDQRBJM6vgOAv1jQ=";
  };
  patches = [
    # Fixes https://github.com/pydata/xarray/issues/9873
    (fetchpatch {
      name = "xarray-PR9879-fix-tests.patch";
      url = "https://github.com/pydata/xarray/commit/50f3a04855d7cf79ddf132ed07d74fb534e57f3a.patch";
      hash = "sha256-PKYzzBOG1Dccpt9D7rcQV1Hxgw11mDOAx3iUfD0rrUc=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    packaging
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xarray" ];

  meta = {
    changelog = "https://github.com/pydata/xarray/blob/${src.rev}/doc/whats-new.rst";
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      doronbehar
    ];
  };
}
