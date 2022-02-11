{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, asdf
, astropy
, setuptools-scm
, astropy-helpers
, astropy-extension-helpers
, beautifulsoup4
, drms
, glymur
, h5netcdf
, hypothesis
, matplotlib
, numpy
, pandas
, parfive
, pytestCheckHook
, pytest-astropy
, pytest-mock
, python-dateutil
, scikitimage
, scipy
, sqlalchemy
, towncrier
, tqdm
, zeep
}:

buildPythonPackage rec {
  pname = "sunpy";
  version = "3.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4acb05a05c7e6a2090cd0bb426b34c7e1620be0de2bf90a95a3f48ba15a5fce2";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asdf
    astropy
    astropy-helpers
    beautifulsoup4
    drms
    glymur
    h5netcdf
    matplotlib
    numpy
    pandas
    parfive
    python-dateutil
    scikitimage
    scipy
    sqlalchemy
    towncrier
    tqdm
    zeep
  ];

  checkInputs = [
    hypothesis
    pytest-astropy
    pytest-mock
    pytestCheckHook
  ];

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
  ];

  disabledTestPaths = [
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/helioprojective-1.0.0.yaml"
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/heliocentric-1.0.0.yaml"
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/heliographic_carrington-*.yaml"
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/geocentricearthequatorial-1.0.0.yaml"
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/geocentricsolarecliptic-1.0.0.yaml"
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/heliocentricearthecliptic-1.0.0.yaml"
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/heliocentricinertial-1.0.0.yaml"
    "sunpy/io/special/asdf/schemas/sunpy.org/sunpy/map/generic_map-1.0.0.yaml"
    # requires mpl-animators package
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
    # requires cdflib package
    "sunpy/timeseries/tests/test_timeseries_factory.py"
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
    maintainers = with maintainers; [ costrouc ];
  };
}
