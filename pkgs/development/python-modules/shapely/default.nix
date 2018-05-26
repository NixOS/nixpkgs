{ stdenv, buildPythonPackage, fetchPypi
, geos, glibcLocales, pytest, cython
, numpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Shapely";
  version = "1.6.4.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30df7572d311514802df8dc0e229d1660bc4cbdcf027a8281e79c5fc2fcf02f2";
  };

  buildInputs = [ geos glibcLocales cython ];

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ numpy ];

  preConfigure = ''
    export LANG="en_US.UTF-8";
  '';

  patchPhase = let
    libc = if stdenv.isDarwin then "libc.dylib" else "libc.so.6";
  in ''
    sed -i "s|_lgeos = load_dll('geos_c', fallbacks=.*)|_lgeos = load_dll('geos_c', fallbacks=['${geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}'])|" shapely/geos.py
    sed -i "s|free = load_dll('c').free|free = load_dll('c', fallbacks=['${stdenv.cc.libc}/lib/${libc}']).free|" shapely/geos.py
  '';

  # Disable the tests that improperly try to use the built extensions
  checkPhase = ''
    py.test -k 'not test_vectorized and not test_fallbacks' tests
  '';

  meta = with stdenv.lib; {
    description = "Geometric objects, predicates, and operations";
    maintainers = with maintainers; [ knedlsepp ];
    homepage = "https://pypi.python.org/pypi/Shapely/";
  };
}
