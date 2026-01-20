{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  flit-core,
  numba,
  numpy,
  pytestCheckHook,
  scipy,
  xarray,
}:

buildPythonPackage rec {
  pname = "xarray-einstats";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "xarray-einstats";
    tag = "v${version}";
    hash = "sha256-CgyMc2Yvut+1LfH9F2FAd62HuLu+58Xr50txbWj4mYU=";
  };

  build-system = [ flit-core ];

  dependencies = [
    numpy
    scipy
    xarray
  ];

  optional-dependencies = {
    einops = [ einops ];
    numba = [ numba ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "xarray_einstats" ];

  disabledTests = [
    # TypeError
    "test_pinv"
  ];

  meta = {
    description = "Stats, linear algebra and einops for xarray";
    homepage = "https://github.com/arviz-devs/xarray-einstats";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
