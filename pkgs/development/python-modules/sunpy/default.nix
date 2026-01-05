{
  lib,
  asdf,
  asdf-astropy,
  astropy,
  beautifulsoup4,
  buildPythonPackage,
  contourpy,
  dask,
  drms,
  extension-helpers,
  fetchFromGitHub,
  fsspec,
  glymur,
  h5netcdf,
  h5py,
  hypothesis,
  lxml,
  matplotlib,
  numpy,
  opencv-python,
  packaging,
  pandas,
  parfive,
  pyerfa,
  pytest-astropy,
  pytestCheckHook,
  pytest-mock,
  python-dateutil,
  pythonOlder,
  reproject,
  requests,
  scikit-image,
  scipy,
  setuptools,
  setuptools-scm,
  tqdm,
  writableTmpDirAsHomeHook,
  zeep,
}:

buildPythonPackage rec {
  pname = "sunpy";
  version = "7.0.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = "sunpy";
    tag = "v${version}";
    hash = "sha256-1LT6Dr9OZYIZkOICSYD8lt5v3Gn1gZGN4GWeJL6IH5w=";
  };

  # As of 2025-10-15, this requires numpy >=1.25.0,<2.3.
  # (The >=1.25.0 constraint is in dependencies, the <2.3 in build-system)
  # We can't use 1.x because it's not supported on Python 3.13+.
  # And since numpy 2.x is at 2.3.2, it's not supported.
  # However, the upper bound is "for matching the numpy deprecation policy",
  # so relaxing it should be OK. (It silently was overridden previously,
  # due to the use of `format = "setuptools"` instead of `pyproject = true`)
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "numpy>=2.0.0rc1,<2.3" "numpy"
  '';

  build-system = [
    extension-helpers
    setuptools
    setuptools-scm # Technically needs setuptools-scm[toml], but that's our default.
    numpy
  ];

  dependencies = [
    astropy
    fsspec
    numpy
    packaging
    parfive
    pyerfa
    requests
  ]
  ++ parfive.optional-dependencies.ftp;

  optional-dependencies = {
    asdf = [
      asdf
      asdf-astropy
    ];
    dask = [ dask ] ++ dask.optional-dependencies.array;
    image = [ scipy ];
    jpeg2000 = [
      glymur
      lxml
    ];
    map = [
      contourpy
      matplotlib
      # mpl-animators
      reproject
      scipy
    ];
    net = [
      beautifulsoup4
      drms
      python-dateutil
      tqdm
      zeep
    ];
    opencv = [ opencv-python ];
    scikit-image = [ scikit-image ];
    # spice = [ spiceypy ];
    timeseries = [
      # cdflib
      h5netcdf
      h5py
      matplotlib
      pandas
    ];
    visualization = [
      matplotlib
      # mpl-animators
    ];

    # We can't use `with` here because "map" would still be the builtin, and
    # we can't below because scikit-image would still be this package's argument.
    core = lib.concatLists [
      optional-dependencies.image
      optional-dependencies.map
      optional-dependencies.net
      optional-dependencies.timeseries
      optional-dependencies.visualization
    ];
    all = lib.concatLists [
      optional-dependencies.core
      optional-dependencies.asdf
      optional-dependencies.jpeg2000
      optional-dependencies.opencv
      # optional-dependencies.spice
      optional-dependencies.scikit-image
    ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-astropy
    pytestCheckHook
    pytest-mock
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.all;

  disabledTests = [
    "rst" # Docs
    "test_print_params" # Needs to be online
    "test_find_dependencies" # Needs cdflib
    # Needs mpl-animators
    "sunpy.coordinates.utils.GreatArc"
    "test_expand_list_generator_map"
    "test_great_arc_different_observer"
    "test_great_arc_points_differentiates"
    "test_great_arc_wrongly_formatted_points"
    "test_main_exclude_remote_data"
    "test_main_include_remote_data"
    "test_main_nonexisting_module"
    "test_main_only_remote_data"
    "test_main_stdlib_module"
    "test_main_submodule_map"
    "test_tai_seconds"
    "test_utime"
  ];

  disabledTestPaths = [
    # Tests are very slow
    "sunpy/net/tests/test_fido.py"
    "sunpy/net/tests/test_scraper.py"
    # asdf.extensions plugin issue
    "sunpy/io/special/asdf/resources/manifests/*.yaml"
    "sunpy/io/special/asdf/resources/schemas/"
    # Requires mpl-animators
    "sunpy/coordinates/tests/test_wcs_utils.py"
    "sunpy/image/tests/test_resample.py"
    "sunpy/image/tests/test_transform.py"
    "sunpy/io/special/asdf/tests/test_genericmap.py"
    "sunpy/map"
    "sunpy/net/jsoc/tests/test_jsoc.py"
    "sunpy/physics/differential_rotation.py"
    "sunpy/physics/tests/test_differential_rotation.py"
    "sunpy/visualization"
    # Requires cdflib
    "sunpy/io/tests/test_cdf.py"
    "sunpy/timeseries"
    # Requires jplephem
    "sunpy/io/special/asdf/tests/test_coordinate_frames.py"
    # Requires spiceypy
    "sunpy/coordinates/tests/test_spice.py"
  ];

  pytestFlags = [ "-Wignore::DeprecationWarning" ];

  pythonImportsCheck = [ "sunpy" ];

  meta = with lib; {
    description = "Python for Solar Physics";
    homepage = "https://sunpy.org";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
