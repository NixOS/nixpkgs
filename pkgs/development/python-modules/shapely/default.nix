{ stdenv, buildPythonPackage, fetchPypi, substituteAll
, geos, pytest, cython
, numpy
}:

buildPythonPackage rec {
  pname = "Shapely";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07lmrihj6pa7f99m97hbf2anqlhhwippcdz03bqkyihnlkhry6p2";
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
    (substituteAll {
      src = ./library-paths.patch;
      libgeos_c = GEOS_LIBRARY_PATH;
      libc = "${stdenv.cc.libc}/lib/libc${stdenv.hostPlatform.extensions.sharedLibrary}"
               + stdenv.lib.optionalString (!stdenv.isDarwin) ".6";
    })
  ];

  # Disable the tests that improperly try to use the built extensions
  checkPhase = ''
    rm -r shapely # prevent import of local shapely
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Geometric objects, predicates, and operations";
    maintainers = with maintainers; [ knedlsepp ];
    homepage = "https://pypi.python.org/pypi/Shapely/";
  };
}
