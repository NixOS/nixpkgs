{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "slicerator";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RAEKf1zYdoDAchO1yr6B0ftxJSlilD5Tc+59FGBdYEY=";
  };

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  # run_tests.py not packaged with pypi release
  doCheck = false;

  meta = {
    description = "Lazy-loading, fancy-sliceable iterable";
    homepage = "https://github.com/soft-matter/slicerator";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
}
