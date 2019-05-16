{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.5.5";

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "matiasb";
    repo = "python-unidiff";
    rev = "v${version}";
    sha256 = "1nvi7s1nn5p7j6aql1nkn2kiadnfby98yla5m3jq8xwsx0aplwdm";
  };

  meta = with lib; {
    description = "Unified diff python parsing/metadata extraction library";
    homepage = https://github.com/matiasb/python-unidiff;
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
