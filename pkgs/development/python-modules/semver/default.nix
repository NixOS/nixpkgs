{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "semver";
  version = "3.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-semver";
    repo = "python-semver";
    rev = "refs/tags/${version}";
    hash = "sha256-772PSUq1dqtn9aOol+Bo0S0OItBmoiCNP8q/YCBvKU4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

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
    changelog = "https://github.com/python-semver/python-semver/releases/tag/3.0.0";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
