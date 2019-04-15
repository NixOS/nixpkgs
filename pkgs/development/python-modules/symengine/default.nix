{ lib
, buildPythonPackage
, fetchPypi
, cython
, cmake
, symengine
, nose
}:

buildPythonPackage rec {
  pname = "symengine";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e86d13aadc9f765f2c5462da32950edd36d1a0a52dbfc96e766be3689957c04d";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"cmake\"" "\"${cmake}/bin/cmake\""

    substituteInPlace cmake/FindCython.cmake \
      --replace "SET(CYTHON_BIN cython" "SET(CYTHON_BIN ${cython}/bin/cython"
  '';

  buildInputs = [ cython cmake ];

  setupPyBuildFlags = [ "--symengine-dir=${symengine}/" ];

  # tests fail due to trying to import local "symengine" directory
  doCheck = false;
  checkPhase = ''
    nosetests symengine/tests -v
  '';

  meta = with lib; {
    description = "Python library providing wrappers to SymEngine";
    homepage = https://github.com/symengine/symengine.py;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
