{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  astropy,
  casa-formats-io,
  dask,
  joblib,
  numpy,
  packaging,
  radio-beam,
  tqdm,

  # tests
  aplpy,
  pytest-astropy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "radio-astro-tools";
    repo = "spectral-cube";
    tag = "v${version}";
    hash = "sha256-fBjbovBXqUfX8rG8gEM3BY5p0BLfa4n1PMbPpPJPDgQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    astropy
    casa-formats-io
    dask
    joblib
    numpy
    packaging
    radio-beam
    tqdm
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    aplpy
    pytest-astropy
    pytestCheckHook
  ];

  # Tests must be run in the build directory.
  preCheck = ''
    cd build/lib
  '';

  pytestFlags = [
    # FutureWarning: Can't acquire a memory view of a Dask array. This will raise in the future
    # https://github.com/radio-astro-tools/spectral-cube/issues/943
    "-Wignore::FutureWarning"
  ];

  disabledTests = [
    # AttributeError: 'DaskSpectralCube' object has no attribute 'dtype'
    "test_key_access_valid"

    # For some reason, those tests are failing with "FutureWarning: Can't acquire a memory view of a Dask array."
    # without being caught by the `-W ignore::FutureWarning` flag above.
    "test_1d_slice_reductions"
    "test_1d_slice_round"
    "test_1d_slices"
    "test_1dcomparison_mask_1d_index"
    "test_1dmask_indexing"
    "test_2dcomparison_mask_1d_index"
    "test_3d_beams_roundtrip"
    "test_4d_beams_roundtrip"
    "test_LDO_arithmetic"
    "test_add"
    "test_apply_everywhere"
    "test_apply_everywhere_plusminus"
    "test_apply_function_parallel_shape"
    "test_attributes"
    "test_basic_arrayness"
    "test_basic_unit_conversion"
    "test_basic_unit_conversion_beams"
    "test_beam_jpix_checks_array"
    "test_beam_jtok"
    "test_beam_jtok_2D"
    "test_beam_jtok_array"
    "test_beam_proj_meta"
    "test_beams_convolution"
    "test_beams_convolution_equal"
    "test_casa_read_basic"
    "test_convolution"
    "test_convolve_to_equal"
    "test_convolve_to_jybeam_multibeams"
    "test_convolve_to_jybeam_onebeam"
    "test_convolve_to_with_bad_beams"
    "test_cube_add"
    "test_cube_stacking"
    "test_cube_with_swapped_axes"
    "test_div"
    "test_filled"
    "test_getitem"
    "test_getitem_vrsc"
    "test_how_withfluxunit"
    "test_initialization_from_units"
    "test_mask_none"
    "test_mosaic_cube"
    "test_mul"
    "test_mul_cubes"
    "test_multibeams_unit_conversions_general_1D"
    "test_numpy_ma_tools"
    "test_oned_slic"
    "test_oned_slice_beams"
    "test_padding_direction"
    "test_pow"
    "test_preserves_header_meta_values"
    "test_proj_meta"
    "test_regression_719"
    "test_repr_1d"
    "test_slice_wcs"
    "test_slicing"
    "test_spatial_smooth_g2d"
    "test_spatial_smooth_maxfilter"
    "test_spatial_smooth_median"
    "test_spatial_smooth_t2d"
    "test_spatial_world"
    "test_spectral_interpolate"
    "test_spectral_interpolate_reversed"
    "test_spectral_interpolate_varying_chunksize"
    "test_spectral_interpolate_with_fillvalue"
    "test_spectral_interpolate_with_mask"
    "test_spectral_slice_preserve_units"
    "test_spectral_smooth"
    "test_spectral_units"
    "test_stacking"
    "test_stacking_badvels"
    "test_stacking_noisy"
    "test_stacking_reversed_specaxis"
    "test_stacking_woffset"
    "test_stacking_wpadding"
    "test_subtract"
    "test_subtract_cubes"
    "test_unit_conversions_general"
    "test_unit_conversions_general_1D"
    "test_unit_conversions_general_2D"
    "test_varyres_mask"
    "test_varyres_spectra"
    "test_varyres_unitconversion_roundtrip"
    "test_with_flux_unit"
    "test_with_spectral_unit"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky: AssertionError: assert diffvals.max()*u.B <= 1*u.MB
    "test_reproject_3D_memory"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # On x86_darwin, this test fails with "Fatal Python error: Aborted"
    # when sandbox = true.
    "spectral_cube/tests/test_visualization.py"
  ];

  pythonImportsCheck = [ "spectral_cube" ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "https://spectral-cube.readthedocs.io";
    changelog = "https://github.com/radio-astro-tools/spectral-cube/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
