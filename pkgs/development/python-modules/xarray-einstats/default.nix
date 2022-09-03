{ lib
, buildPythonPackage
, einops
, fetchFromGitHub
, flit-core
, numba
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, scipy
, xarray
}:

buildPythonPackage rec {
  pname = "xarray-einstats";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-N8ievasPaqusx51FCxcl1FGIjXooyBsRqsuRU73puRM=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    xarray
  ];

  checkInputs = [
    einops
    numba
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xarray_einstats"
  ];

  pytestFlagsArray = [
    "src/xarray_einstats/tests/"
  ];

  meta = with lib; {
    description = "Stats, linear algebra and einops for xarray";
    homepage = "https://github.com/arviz-devs/xarray-einstats";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
