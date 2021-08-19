{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.7.0";

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "matiasb";
    repo = "python-unidiff";
    rev = "v${version}";
    sha256 = "1s1l327jqm0r35pn9c83pbw15k66x8klw1lf45xqp8lrdc15cqv5";
  };

  meta = with lib; {
    description = "Unified diff python parsing/metadata extraction library";
    homepage = "https://github.com/matiasb/python-unidiff";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
