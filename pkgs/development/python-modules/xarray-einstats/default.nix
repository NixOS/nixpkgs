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
<<<<<<< HEAD
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-TXuNqXsny7VpJqV5/3riKzXLheZl+qF+zf4SCMipzmw=";
=======
    hash = "sha256-oDrNR7iVDg7Piti6JNaXGekfrUfK5GWJYbH/g6m4570=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
