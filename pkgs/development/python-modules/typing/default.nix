{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy3k, python }:

let
  testDir = if isPy3k then "src" else "python2";

in buildPythonPackage rec {
  pname = "typing";
  version = "3.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d400a9344254803a2368533e4533a4200d21eb7b6b729c173bc38201a74db3f2";
  };

  # Error for Python3.6: ImportError: cannot import name 'ann_module'
  # See https://github.com/python/typing/pull/280
  doCheck = pythonOlder "3.6";

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
