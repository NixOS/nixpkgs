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
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TXuNqXsny7VpJqV5/3riKzXLheZl+qF+zf4SCMipzmw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    xarray
  ];

  nativeCheckInputs = [
    einops
    numba
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xarray_einstats"
  ];

  meta = with lib; {
    description = "Stats, linear algebra and einops for xarray";
    homepage = "https://github.com/arviz-devs/xarray-einstats";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
