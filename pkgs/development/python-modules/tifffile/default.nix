{ lib
, buildPythonPackage
, dask
, fetchPypi
, fsspec
, lxml
, numpy
, pytestCheckHook
, pythonOlder
, zarr
}:

buildPythonPackage rec {
  pname = "tifffile";
  version = "2022.3.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bZQ/LAGxo0pHbJY9EZVl+6EI9VngYUJsY6UVeEaVntk=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    dask
    fsspec
    lxml
    pytestCheckHook
    zarr
  ];

  disabledTests = [
    # Test require network access
    "test_class_omexml"
    "test_write_ome"
    # Test file is missing
    "test_write_predictor"
  ];

  pythonImportsCheck = [
    "tifffile"
  ];

  meta = with lib; {
    description = "Read and write image data from and to TIFF files";
    homepage = "https://github.com/cgohlke/tifffile/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lebastr ];
  };
}
