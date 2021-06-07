{ buildPythonPackage, fetchFromGitHub, lib, pythonOlder }:
buildPythonPackage rec {
  pname = "typed-ast";
  version = "1.4.1";
  src = fetchFromGitHub{
    owner = "python";
    repo = "typed_ast";
    rev = version;
    sha256 = "086r9qhls6mz1w72a6d1ld3m4fbkxklf6mgwbs8wpw0zlxjm7y40";
  };
  # Only works with Python 3.3 and newer;
  disabled = pythonOlder "3.3";
  # No tests in archive
  doCheck = false;
  meta = {
    homepage = "https://pypi.python.org/pypi/typed-ast";
    description = "a fork of Python 2 and 3 ast modules with type comment support";
    license = lib.licenses.asl20;
  };
}
