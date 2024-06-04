{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "slicerator";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RAEKf1zYdoDAchO1yr6B0ftxJSlilD5Tc+59FGBdYEY=";
  };

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  # run_tests.py not packaged with pypi release
  doCheck = false;

  meta = with lib; {
    description = "A lazy-loading, fancy-sliceable iterable";
    homepage = "https://github.com/soft-matter/slicerator";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
