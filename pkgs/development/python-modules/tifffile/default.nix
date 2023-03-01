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
  version = "2023.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RY31rZpSF/Zo7dY23Bn7xzYGK/eKrII6uEzbrp3o6qY=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
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
    "test_issue_imagej_hyperstack_arg"
    "test_issue_description_overwrite"
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
    changelog = "https://github.com/cgohlke/tifffile/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lebastr ];
  };
}
