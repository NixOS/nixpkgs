{lib, python, buildPythonPackage, isPyPy, gfortran, nose}:

args:

let
  inherit (args) version;
  inherit (args) numpy;
in buildPythonPackage (args // rec {

  name = "scipy-${version}";

  buildInputs = (args.buildInputs or [ gfortran nose ]);
  propagatedBuildInputs = (args.propagatedBuildInputs or [ passthru.blas numpy]);

  # Remove tests because of broken wrapper
  prePatch = ''
    rm scipy/linalg/tests/test_lapack.py
  '';

  preConfigure = ''
    sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
  '';

  preBuild = ''
    echo "Creating site.cfg file..."
    cat << EOF > site.cfg
    [openblas]
    include_dirs = ${passthru.blas}/include
    library_dirs = ${passthru.blas}/lib
    EOF
  '';

  checkPhase = ''
    runHook preCheck
    pushd dist
    ${python.interpreter} -c 'import scipy; scipy.test("fast", verbose=10)'
    popd
    runHook postCheck
  '';

  passthru = {
    blas = numpy.blas;
  };

  setupPyBuildFlags = [ "--fcompiler='gnu95'" ];

  meta = {
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering. ";
    homepage = http://www.scipy.org/;
    maintainers = with lib.maintainers; [ fridh ];
  } // (args.meta or {});
})
