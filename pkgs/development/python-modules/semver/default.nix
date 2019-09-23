{ stdenv, fetchFromGitHub, buildPythonPackage, pytest }:

buildPythonPackage {
  pname = "semver";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "k-bx";
    repo = "python-semver";
    rev = "41775dd5f143dfa6ca94885056c9ef5b3ed4e6e1"; # not tagged in repository
    sha256 = "1rqaakha4sw06k9h0h4g1wmk66zkmhpq92y2rw0kyfpp6xk1zbk2";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = https://github.com/k-bx/python-semver;
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
