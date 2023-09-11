{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-mock";
  version = "5.1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8H1Z3lDqgWq0A7pOJG/4CwCSY7N3vD93Tf3r8LQD+2A=";
  };

  meta = {
    description = "This is a PEP 561 type stub package for the mock package. It can be used by type-checking tools like mypy, pyright, pytype, PyCharm, etc. to check code that uses mock.";
    homepage = "https://pypi.org/project/types-mock";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
