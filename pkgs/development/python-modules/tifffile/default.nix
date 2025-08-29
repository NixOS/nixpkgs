{
  lib,
  buildPythonPackage,
  dask,
  fetchPypi,
  fsspec,
  lxml,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zarr,
}:

buildPythonPackage rec {
  pname = "tifffile";
  version = "2025.6.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ds5MLnoQZWlX1Wigk7B1E8ByjTDBvYzBJyWQH//bcUM=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

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
    # Test file is missing
    "test_issue_invalid_predictor"
  ];

  pythonImportsCheck = [ "tifffile" ];

  # flaky, often killed due to OOM or timeout
  env.SKIP_LARGE = "1";

  meta = {
    description = "Read and write image data from and to TIFF files";
    homepage = "https://github.com/cgohlke/tifffile/";
    changelog = "https://github.com/cgohlke/tifffile/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lebastr ];
  };
}
