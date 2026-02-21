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

buildPythonPackage (finalAttrs: {
  pname = "xarray-einstats";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "xarray-einstats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/CbCaToW9U0+WqayE33gSyx5wKrhlZd7w4kjyxoxrk=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
})
