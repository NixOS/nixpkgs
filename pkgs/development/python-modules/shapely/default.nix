{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, substituteAll
, pythonOlder
, geos
, pytestCheckHook
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "shapely";
  version = "2.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EfGxIxpsBCE/sSJsaWjRsbOzaexC0ellUGavh2MYYOo=";
  };

  nativeBuildInputs = [
    geos # for geos-config
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Environment variable used in setup.py
  GEOS_LIBRARY_PATH = "${geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";

  preCheck = ''
    rm -r shapely # prevent import of local shapely
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
    description = "Geometric objects, predicates, and operations";
    homepage = "https://pypi.python.org/pypi/Shapely/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ knedlsepp ];
  };
}
