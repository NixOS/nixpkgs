{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, bz2file
, setuptools
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "screed";
  version = "1.1.1";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EB4ZNImNLUoU+dnJd3S4wTyQpmuNK3NLtakPsO1iCbU=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonImportsCheck = [ "screed" ];
  checkInputs = [ pytestCheckHook ];

  # These tests use the screed CLI and make assumptions on how screed is
  # installed that break with nix. Can be enabled when upstream is fixed.
  disabledTests = [
    "Test_convert_shell"
    "Test_fa_shell_command"
    "Test_fq_shell_command"
  ];

  propagatedBuildInputs = [ bz2file setuptools ];

  meta = with lib; {
    description = "A simple read-only sequence database, designed for short reads";
    homepage = "https://pypi.org/project/screed/";
    maintainers = with maintainers; [ luizirber ];
    license = licenses.bsd3;
  };
}
