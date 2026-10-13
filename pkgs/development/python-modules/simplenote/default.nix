{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "simplenote";
  version = "2.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "simplenote-vim";
    repo = "simplenote.py";
    rev = "v${version}";
    hash = "sha256-pUHeUbDHMpAfIhrTsltExI2vlIBPW6qalx0u3/7bO78=";
  };

  meta = {
    description = "Python library for the simplenote.com web service";
    homepage = "http://readthedocs.org/docs/simplenotepy/en/latest/api.html";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
