{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, substituteAll
, pythonOlder
, geos
, pytestCheckHook
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "Shapely";
  version = "1.8.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vyr51QBv1eMhPjfuVIkSsDQfsmck1tyKTjlQwQGX67Y=";
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

  # Environment variable used in shapely/_buildcfg.py
  GEOS_LIBRARY_PATH = "${geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";

  patches = [
    # Patch to search form GOES .so/.dylib files in a Nix-aware way
    (substituteAll {
      src = ./library-paths.patch;
      libgeos_c = GEOS_LIBRARY_PATH;
      libc = lib.optionalString (!stdenv.isDarwin) "${stdenv.cc.libc}/lib/libc${stdenv.hostPlatform.extensions.sharedLibrary}.6";
    })
    (fetchpatch {
      name = "fix-tests-geos-3.11.patch";
      url = "https://github.com/shapely/shapely/commit/21c8e8a7909e7fb3cce6daa5c5b8284ac927fcb0.patch";
      includes = [ "tests/test_parallel_offset.py" ];
      sha256 = "sha256-85c8NlmAzzfCgepe/411ug5Sq+665dFMb3ySaUt9Kew=";
    })
 ];

  preCheck = ''
    rm -r shapely # prevent import of local shapely
  '';

  disabledTests = [
    "test_collection"
  ];

  pythonImportsCheck = [ "shapely" ];

  meta = with lib; {
    description = "Geometric objects, predicates, and operations";
    homepage = "https://pypi.python.org/pypi/Shapely/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ knedlsepp ];
  };
}
