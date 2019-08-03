{ stdenv, buildPythonPackage, fetchPypi, substituteAll
, geos, pytest, cython
, numpy
}:

buildPythonPackage rec {
  pname = "Shapely";
  version = "1.6.4.post2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4b87bb61fc3de59fc1f85e71a79b0c709dc68364d9584473697aad4aa13240f";
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
