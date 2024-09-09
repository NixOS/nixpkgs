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
    sha256 = "1grvvgzdybhxjydalnsgh2aaz3f48idv5lqs48gr0cn7n18xwhd5";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "Python library for the simplenote.com web service";
    homepage = "http://readthedocs.org/docs/simplenotepy/en/latest/api.html";
    license = licenses.mit;
    maintainers = [ ];
  };
}
