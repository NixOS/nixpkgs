{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "semver";
  version = "2.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-semver";
    repo = "python-semver";
    rev = version;
    hash = "sha256-IWTo/P9JRxBQlhtcH3JMJZZrwAA8EALF4dtHajWUc4w=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--no-cov-on-fail/d" setup.cfg
  '';

  disabledTestPaths = [
    # Don't test the documentation
    "docs/*.rst"
  ];

  pythonImportsCheck = [
    "semver"
  ];

  meta = with lib; {
    description = "Python package to work with Semantic Versioning (http://semver.org/)";
    homepage = "https://python-semver.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
