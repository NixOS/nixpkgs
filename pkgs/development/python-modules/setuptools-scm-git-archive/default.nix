{ lib, buildPythonPackage, fetchPypi, setuptools-scm, pytestCheckHook }:

buildPythonPackage rec {
  pname = "setuptools-scm-git-archive";
  version = "1.4.1";

  src = fetchPypi {
    inherit version;
    pname = "setuptools_scm_git_archive";
    sha256 = "sha256-xBi8d7OXTTrGXyaPBY8j4B3F+ZHyIzEosOFqad4iewk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [ "setuptools_scm_git_archive" ];

  meta = with lib; {
    description = "setuptools_scm plugin for git archives";
    homepage = "https://github.com/Changaco/setuptools_scm_git_archive";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
