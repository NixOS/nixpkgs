{ buildPythonPackage, fetchFromGitHub, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.4.0";
  src = fetchFromGitHub{
    owner = "python";
    repo = "typed_ast";
    rev = version;
    sha256 = "0l0hz809f7i356kmqkvfsaswiidb98j9hs9rrjnfawzqcbffzgyb";
  };
  # Only works with Python 3.3 and newer;
  disabled = pythonOlder "3.3";
  # No tests in archive
  doCheck = false;
  meta = {
    homepage = https://pypi.python.org/pypi/typed-ast;
    description = "a fork of Python 2 and 3 ast modules with type comment support";
    license = lib.licenses.asl20;
  };
}
