{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "screed";
  version = "1.1.2";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c0/6eopkUoZJbYlbc2+R1rKYiVbi/UI1gSPZPshRm2o=";
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

  meta = with lib; {
    description = "A simple read-only sequence database, designed for short reads";
    homepage = "https://pypi.org/project/screed/";
    maintainers = with maintainers; [ luizirber ];
    license = licenses.bsd3;
  };
}
