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
  version = "3.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "codrsquad";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kX7S5NSqO1LDRkfBHaNfTjzW+l0Pd+5KvQHiNF3eH/M=";
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
