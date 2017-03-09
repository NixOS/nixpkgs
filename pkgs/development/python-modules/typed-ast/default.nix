{ buildPythonPackage, fetchzip, isPy3k, lib, pythonOlder }:
buildPythonPackage rec {
  name = "typed-ast-${version}";
  version = "1.0.1";
  src = fetchzip {
    url = "mirror://pypi/t/typed-ast/${name}.zip";
    sha256 = "1q69czr9ghnbd81hay71kgynn6mqi5nsgand9yw6dyw5bim5l154";
  };
  # Only works with Python 3.3 and newer;
  disabled = !isPy3k && !(pythonOlder "3.3");
  meta = {
    homepage = "https://pypi.python.org/pypi/typed-ast";
    description = "a fork of Python 2 and 3 ast modules with type comment support";
    license = lib.licenses.asl20;
  };
}
