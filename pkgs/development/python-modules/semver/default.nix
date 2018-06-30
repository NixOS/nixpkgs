{ stdenv, fetchFromGitHub, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "semver";
  version = "2.7.9";

  src = fetchFromGitHub {
    owner = "k-bx";
    repo = "python-semver";
    rev = "2001c62d1a0361c44acc7076d8ce91e1d1c66141"; # not tagged in repository
    sha256 = "01c05sv97dyr672sa0nr3fnh2aqbmvkfw19d6rkaj16h2sdsyg0i";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest -v tests.py";

  meta = with stdenv.lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = https://github.com/k-bx/python-semver;
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
