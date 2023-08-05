{ lib
, attrs
, buildPythonPackage
, click
, fetchFromGitHub
, hatch-vcs
, hatchling
, libcst
, moreorless
, pythonOlder
, stdlibs
, toml
, trailrunner
, unittestCheckHook
, volatile
}:

buildPythonPackage rec {
  pname = "usort";
  version = "1.1.0b2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "usort";
    rev = "refs/tags/v${version}";
    hash = "sha256-c3gQ+f/BRgM+Nwc+mEP7dcmig7ws7FqL5zwQhNJJlsI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    click
    libcst
    moreorless
    stdlibs
    toml
    trailrunner
  ];

  nativeCheckInputs = [
    unittestCheckHook
    volatile
  ];

  pythonImportsCheck = [
    "usort"
  ];

  meta = with lib; {
    description = "Safe, minimal import sorting for Python projects";
    homepage = "https://github.com/facebook/usort";
    changelog = "https://github.com/facebook/usort/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
