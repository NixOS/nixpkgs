{ lib
, stdenv
, asdf
, astropy
, astropy-extension-helpers
, astropy-helpers
, beautifulsoup4
, buildPythonPackage
, drms
, fetchPypi
, glymur
, h5netcdf
, hypothesis
, lxml
, matplotlib
, numpy
, pandas
, parfive
, pytest-astropy
, pytestCheckHook
, pytest-mock
, python-dateutil
, pythonOlder
, scikit-image
, scipy
, setuptools-scm
, sqlalchemy
, tqdm
, zeep
}:

buildPythonPackage rec {
  pname = "sunpy";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7tmyywyfQw1T9qr5UbPH/KR+AmmhSaHunkeUGRKDl+Q=";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    astropy-helpers
    numpy
    parfive
  ];

  passthru.optional-dependencies = {
    asdf = [
      asdf
      # asdf-astropy
    ];
    database = [
      sqlalchemy
    ];
    image = [
      scikit-image
      scipy
    ];
    net = [
      beautifulsoup4
      drms
      python-dateutil
      tqdm
      zeep
    ];
    jpeg2000 = [
      glymur
      lxml
    ];
    timeseries = [
      # cdflib
      h5netcdf
      # h5py
      matplotlib
      pandas
    ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-astropy
    pytest-mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.asdf
    ++ passthru.optional-dependencies.database
    ++ passthru.optional-dependencies.image
    ++ passthru.optional-dependencies.net
    ++ passthru.optional-dependencies.timeseries;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --dist no" ""
  '';

  # darwin has write permission issues
  doCheck = stdenv.isLinux;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    "rst"
    "test_sunpy_warnings_logging"
    "test_main_nonexisting_module"
    "test_main_stdlib_module"
    "test_find_dependencies"
  ];

  disabledTestPaths = [
    # Tests are very slow
    "sunpy/net/tests/test_fido.py"
    # asdf.extensions plugin issue
    "sunpy/io/special/asdf/resources/schemas/"
    "sunpy/io/special/asdf/resources/manifests/sunpy-1.0.0.yaml"
    # Requires mpl-animators package
    "sunpy/map/tests/test_compositemap.py"
    "sunpy/map/tests/test_mapbase.py"
    "sunpy/map/tests/test_mapsequence.py"
    "sunpy/map/tests/test_plotting.py"
    "sunpy/map/tests/test_reproject_to.py"
    "sunpy/net/tests/test_helioviewer.py"
    "sunpy/timeseries/tests/test_timeseriesbase.py"
    "sunpy/visualization/animator/tests/test_basefuncanimator.py"
    "sunpy/visualization/animator/tests/test_mapsequenceanimator.py"
    "sunpy/visualization/animator/tests/test_wcs.py"
    "sunpy/visualization/colormaps/tests/test_cm.py"
    # Requires cdflib package
    "sunpy/timeseries/tests/test_timeseries_factory.py"
    # Requires jplephem
    "sunpy/image/tests/test_transform.py"
    "sunpy/io/special/asdf/tests/test_coordinate_frames.py"
    "sunpy/io/special/asdf/tests/test_genericmap.py"
    # distutils is deprecated
    "sunpy/io/setup_package.py"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  # Wants a configuration file
  # pythonImportsCheck = [
  #   "sunpy"
  # ];

  meta = with lib; {
    description = "Python for Solar Physics";
    homepage = "https://sunpy.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    broken = true;
  };
}
