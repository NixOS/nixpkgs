{ lib
, buildPythonPackage
, fetchFromGitHub
, git
, mock
, pep440
, pytestCheckHook
, pythonOlder
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "setupmeta";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "codrsquad";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HNGoLCTidgnaU5QA+0d/PQuCswigjdvQC3/w19i+Xuc=";
  };

  preBuild = ''
    export PYGRADLE_PROJECT_VERSION=${version};
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    git
    mock
    pep440
    pytestCheckHook
    six
  ];

  preCheck = ''
    unset PYGRADLE_PROJECT_VERSION
  '';

  disabledTests = [
    # Tests want to scan site-packages
    "test_check_dependencies"
    "test_clean"
    "test_scenario"
    "test_git_versioning"
    # setuptools.installer and fetch_build_eggs are deprecated.
    # Requirements should be satisfied by a PEP 517 installer.
    "test_brand_new_project"
  ];

  pythonImportsCheck = [
    "setupmeta"
  ];

  meta = with lib; {
    description = "Python module to simplify setup.py files";
    homepage = "https://github.com/codrsquad/setupmeta";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
