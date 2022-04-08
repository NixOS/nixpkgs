{ lib
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "slicerator";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RAEKf1zYdoDAchO1yr6B0ftxJSlilD5Tc+59FGBdYEY=";
  };

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  # run_tests.py not packaged with pypi release
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/soft-matter/slicerator";
    description = "A lazy-loading, fancy-sliceable iterable";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
