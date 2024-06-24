{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  substituteAll,

  cython_0,
  geos_3_11,
  numpy,
  oldest-supported-numpy,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "shapely";
  version = "1.8.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Shapely";
    inherit version;
    hash = "sha256-6CttYOz7EkEgyI/hBqR4WWu+qxQhFtfn9ko2TayQKpI=";
  };

  # Environment variable used in shapely/_buildcfg.py
  GEOS_LIBRARY_PATH = "${geos_3_11}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";

  patches = [
    # Patch to search form GOES .so/.dylib files in a Nix-aware way
    (substituteAll {
      src = ./library-paths.patch;
      libgeos_c = GEOS_LIBRARY_PATH;
      libc = lib.optionalString (
        !stdenv.isDarwin
      ) "${stdenv.cc.libc}/lib/libc${stdenv.hostPlatform.extensions.sharedLibrary}.6";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace "setuptools<64" "setuptools"
  '';

  nativeBuildInputs = [
    cython_0
    geos_3_11 # for geos-config
    oldest-supported-numpy
    setuptools
    wheel
  ];

  buildInputs = [ geos_3_11 ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    changelog = "https://github.com/shapely/shapely/blob/${version}/CHANGES.txt";
    description = "Manipulation and analysis of geometric objects";
    homepage = "https://github.com/shapely/shapely";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
