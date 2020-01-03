{ stdenv
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "slicerator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18e60393e6765ca96986f801bbae62a617a1eba6ed57784e61b165ffc7dc1848";
  };

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  # run_tests.py not packaged with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/soft-matter/slicerator;
    description = "A lazy-loading, fancy-sliceable iterable";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
