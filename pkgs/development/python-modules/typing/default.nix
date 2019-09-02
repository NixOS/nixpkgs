{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy3k, isPyPy, python }:

let
  testDir = if isPy3k then "src" else "python2";

in buildPythonPackage rec {
  pname = "typing";
  version = "3.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kj4kvkh89psajxlyb72rm5fr7w70yb32zkj2h174arsz325wxjk";
  };

  # Error for Python3.6: ImportError: cannot import name 'ann_module'
  # See https://github.com/python/typing/pull/280
  # Also, don't bother on PyPy: AssertionError: TypeError not raised
  doCheck = pythonOlder "3.6" && !isPyPy;

  checkPhase = ''
    cd ${testDir}
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Backport of typing module to Python versions older than 3.5";
    homepage = https://docs.python.org/3/library/typing.html;
    license = licenses.psfl;
  };
}
