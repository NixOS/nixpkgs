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
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "xarray-einstats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mGRalZ9OSh3CtfhLy2E6LOQVBDoq8c777Q9WnyMtjpU=";
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
    changelog = "https://github.com/arviz-devs/xarray-einstats/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
