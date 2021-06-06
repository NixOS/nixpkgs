{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "semver";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "python-semver";
    repo = "python-semver";
    rev = version;
    sha256 = "sha256-IWTo/P9JRxBQlhtcH3JMJZZrwAA8EALF4dtHajWUc4w=";
  };

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  # Confuses source vs dist imports in pytest
  preCheck = "rm -r dist";

  pythonImportsCheck = [ "semver" ];

  meta = with lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = "https://python-semver.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
