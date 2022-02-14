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
  version = "2022.2.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ftp0EXZDaBuyyqaVtI854iQ7SIf3z5kdWt/9gT5cg3M=";
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
