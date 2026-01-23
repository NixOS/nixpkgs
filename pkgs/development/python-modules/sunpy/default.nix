{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  extension-helpers,
  numpy,
  setuptools,
  setuptools-scm,

  # dependencies
  astropy,
  fsspec,
  packaging,
  parfive,
  pyerfa,
  requests,

  # optional-dependencies
  # asdf
  asdf,
  asdf-astropy,
  # dask
  dask,
  # image
  scipy,
  # jpeg
  glymur,
  lxml,
  # jupyter
  itables,
  ipywidgets,
  # map
  contourpy,
  matplotlib,
  reproject,
  # net
  beautifulsoup4,
  drms,
  python-dateutil,
  tqdm,
  zeep,
  # opencv
  opencv-python,
  # scikit-image
  scikit-image,
  # timeseries
  h5netcdf,
  h5py,
  pandas,

  # tests
  hypothesis,
  pytest-astropy,
  pytest-mock,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sunpy";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = "sunpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FeKmg3dZfbbjt1lDliF4uXf8PvM3J5HWtYqKRriJ4l0=";
  };

  build-system = [
    extension-helpers
    numpy
    setuptools
    setuptools-scm # Technically needs setuptools-scm[toml], but that's our default.
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

  optional-dependencies = lib.fix (self: {
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
    jupyter = [
      itables
      ipywidgets
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
      self.image
      self.map
      self.net
      self.timeseries
      self.visualization
    ];
    all = lib.concatLists [
      self.core
      self.asdf
      self.jpeg2000
      self.opencv
      # optional-dependencies.spice
      self.scikit-image
    ];
  });

  nativeCheckInputs = [
    hypothesis
    pytest-astropy
    pytest-mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  disabledTests = [
    "rst" # Docs
    "test_print_params" # Needs to be online
    "test_find_dependencies" # Needs cdflib
    # Needs mpl-animators
    "sunpy.coordinates.utils.GreatArc"
    "test_cutout_not_on_disk_when_tracking"
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

  pythonImportsCheck = [ "sunpy" ];

  meta = {
    description = "Python for Solar Physics";
    homepage = "https://sunpy.org";
    downloadPage = "github.com/sunpy/sunpy";
    changelog = "https://docs.sunpy.org/en/stable/whatsnew/changelog.html";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
