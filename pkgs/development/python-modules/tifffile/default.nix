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
  version = "2022.5.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sDFHoVhit8HZDUdDUZfxSb73pSwlrWfPH5tGX6pxuNI=";
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
    # AssertionError
    "test_write_bigtiff"
    "test_write_imagej_raw"
    # https://github.com/cgohlke/tifffile/issues/142
    "test_func_bitorder_decode"
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
