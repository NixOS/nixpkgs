{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, substituteAll
, pythonOlder
, geos
, pytest
, cython
, numpy
, fetchpatch
}:

buildPythonPackage rec {
  pname = "Shapely";
  version = "1.7.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0adiz4jwmwxk7k1awqifb1a9bj5x4nx4gglb5dz9liam21674h8n";
  };

  nativeBuildInputs = [
    geos # for geos-config
    cython
  ];

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ numpy ];

  # environment variable used in shapely/_buildcfg.py
  GEOS_LIBRARY_PATH = "${geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";

  patches = [
    # Fix with geos 3.9. This patch will be part of the next release after 1.7.1
    (fetchpatch {
      url = "https://github.com/Toblerity/Shapely/commit/77879a954d24d1596f986d16ba3eff5e13861164.patch";
      sha256 = "1w7ngjqbpf9vnvrfg4nyv34kckim9a60gvx20h6skc79xwihd4m5";
      excludes = [
        "tests/test_create_inconsistent_dimensionality.py"
        "appveyor.yml"
        ".travis.yml"
      ];
    })

    # Patch to search form GOES .so/.dylib files in a Nix-aware way
    (substituteAll {
      src = ./library-paths.patch;
      libgeos_c = GEOS_LIBRARY_PATH;
      libc = lib.optionalString (!stdenv.isDarwin) "${stdenv.cc.libc}/lib/libc${stdenv.hostPlatform.extensions.sharedLibrary}.6";
    })
  ];

  # Disable the tests that improperly try to use the built extensions
  checkPhase = ''
    rm -r shapely # prevent import of local shapely
    py.test tests
  '';

  meta = with lib; {
    description = "Geometric objects, predicates, and operations";
    maintainers = with maintainers; [ knedlsepp ];
    homepage = "https://pypi.python.org/pypi/Shapely/";
  };
}
