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

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

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
   # included in next release.
   (fetchpatch {
     url = "https://github.com/Toblerity/Shapely/commit/ea5b05a0c87235d3d8f09930ad47c396a76c8b0c.patch";
     sha256 = "sha256-egdydlV+tpXosSQwQFHaXaeBhXEHAs+mn7vLUDpvybA=";
   })
 ];

  preCheck = ''
    rm -r shapely # prevent import of local shapely
  '';

  disabledTests = [
    "test_collection"
  ];

  meta = with lib; {
    description = "Geometric objects, predicates, and operations";
    maintainers = with maintainers; [ knedlsepp ];
    homepage = "https://pypi.python.org/pypi/Shapely/";
  };
}
