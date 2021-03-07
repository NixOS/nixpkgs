{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pytestcov
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

  # confuses source vs dist imports in pytest
  preCheck = ''
    rm -r dist
  '';

  checkInputs = [ pytestCheckHook pytestcov ];

  meta = with lib; {
    description = "Python package to work with Semantic Versioning";
    homepage = "https://python-semver.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
