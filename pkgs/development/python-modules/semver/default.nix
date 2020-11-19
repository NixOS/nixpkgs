{ stdenv
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pytestcov
}:

buildPythonPackage rec {
  pname = "semver";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "python-semver";
    repo = "python-semver";
    rev = version;
    sha256 = "0yxjmcgk5iwp53l9z1cg0ajrj18i09ircs11ifpdrggzm8n1blf3";
  };

  preCheck = "rm -rf dist"; # confuses source vs dist imports in pytest
  checkInputs = [ pytestCheckHook pytestcov ];

  meta = with stdenv.lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = "https://python-semver.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
