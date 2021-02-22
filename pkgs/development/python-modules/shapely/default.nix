{ lib, stdenv, buildPythonPackage, fetchPypi, fetchpatch, substituteAll, pythonOlder
, geos, pytest, cython
, numpy
}:

buildPythonPackage rec {
  pname = "Shapely";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0adiz4jwmwxk7k1awqifb1a9bj5x4nx4gglb5dz9liam21674h8n";
  };
  disabled = pythonOlder "3.5";

  nativeBuildInputs = [
    geos # for geos-config
    cython
  ];

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ numpy ];

  # environment variable used in shapely/_buildcfg.py
  GEOS_LIBRARY_PATH = "${geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";

  patches = [
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
