{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.6.0";

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "matiasb";
    repo = "python-unidiff";
    rev = "v${version}";
    sha256 = "0farwkw0nbb5h4369pq3i6pp4047hav0h88ba55rzz5k7mr25rgi";
  };

  meta = with lib; {
    description = "Unified diff python parsing/metadata extraction library";
    homepage = "https://github.com/matiasb/python-unidiff";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
