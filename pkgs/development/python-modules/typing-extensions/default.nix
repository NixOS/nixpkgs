{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy3k, python, typing }:
let
  testDir = if isPy3k then "src_py3" else "src_py2";

in buildPythonPackage rec {
  pname = "typing_extensions";
  version = "3.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15bx773a5zkk4hkwjl8nb5f8y5741vyyqb9q3jac6kxm1frk5mif";
  };

  checkInputs = lib.optional (pythonOlder "3.5") typing;

  # Error for Python3.6: ImportError: cannot import name 'ann_module'
  # See https://github.com/python/typing/pull/280
  doCheck = pythonOlder "3.6";

  checkPhase = ''
    cd ${testDir}
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Backported and Experimental Type Hints for Python 3.5+";
    homepage = https://github.com/python/typing;
    license = licenses.psfl;
    maintainers = with maintainers; [ pmiddend ];
  };
}
