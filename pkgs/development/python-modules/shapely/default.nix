{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,

  cython_0,
  geos,
  numpy,
  oldest-supported-numpy,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "shapely";
  version = "2.0.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v/I2a8eGv6bLNT1rR9BEPFcMMndmEuUn7ke232P8/jI=";
  };

  nativeBuildInputs = [
    cython_0
    geos # for geos-config
    oldest-supported-numpy
    setuptools
    wheel
  ];

  buildInputs = [ geos ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Fix a ModuleNotFoundError. Investigated at:
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  disabledTests = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # FIXME(lf-): these logging tests are broken, which is definitely our
    # fault. I've tried figuring out the cause and failed.
    #
    # It is apparently some sandbox or no-sandbox related thing on macOS only
    # though.
    "test_error_handler_exception"
    "test_error_handler"
    "test_info_handler"
  ];

  pythonImportsCheck = [ "shapely" ];

  meta = with lib; {
    changelog = "https://github.com/shapely/shapely/blob/${version}/CHANGES.txt";
    description = "Manipulation and analysis of geometric objects";
    homepage = "https://github.com/shapely/shapely";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
