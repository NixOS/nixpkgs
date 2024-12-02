{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  flit-core,
  numba,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  xarray,
}:

buildPythonPackage rec {
  pname = "xarray-einstats";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "xarray-einstats";
    rev = "refs/tags/v${version}";
    hash = "sha256-XvxsyH8cwsA9B36uhM1Pr5XaNd0d0/nEamA4axdJe24=";
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

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "xarray_einstats" ];

  disabledTests = [
    # TypeError
    "test_pinv"
  ];

  meta = with lib; {
    description = "Stats, linear algebra and einops for xarray";
    homepage = "https://github.com/arviz-devs/xarray-einstats";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
