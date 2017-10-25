{ stdenv, buildPythonPackage, fetchPypi
, geos, glibcLocales, pytest, cython
, numpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Shapely";
  version = "1.5.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lfqxb3kpdn0g9zzlhzg79yc8iyy4fpsk0p5nd80gar1mmhr8pg7";
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
    sed -i "s|free = load_dll('c').free|free = load_dll('c', fallbacks=['${stdenv.cc.libc}/lib/${stdenv.cc.libc}']).free|" shapely/geos.py
  '';

  # tests/test_voctorized fails because the vectorized extension is not
  # available in when running tests
  checkPhase = ''
    py.test --ignore tests/test_vectorized.py
  '';

  meta = with stdenv.lib; {
    description = "Geometric objects, predicates, and operations";
    maintainers = with maintainers; [ knedlsepp ];
    homepage = "https://pypi.python.org/pypi/Shapely/";
  };
}
