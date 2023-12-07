{ lib, buildPythonPackage, fetchPypi, setuptools-scm, pytestCheckHook }:

buildPythonPackage rec {
  pname = "setuptools-scm-git-archive";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "setuptools_scm_git_archive";
    sha256 = "b048b27b32e1e76ec865b0caa4bb85df6ddbf4697d6909f567ac36709f6ef2f0";
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
