{ stdenv
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  version = "0.9.8";
  pname = "slicerator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b91dd76a415fd8872185cbd6fbf1922fe174359053d4694983fc719e4a0f5667";
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
