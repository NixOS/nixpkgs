{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "screed";
  version = "1.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N+gWl8fbqVoFNVTltahq/zKXBeHPXfxee42lht7gcrg=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "screed" ];
  checkInputs = [ pytestCheckHook ];

  # These tests use the screed CLI and make assumptions on how screed is
  # installed that break with nix. Can be enabled when upstream is fixed.
  disabledTests = [
    "Test_convert_shell"
    "Test_fa_shell_command"
    "Test_fq_shell_command"
  ];

  meta = {
    description = "Simple read-only sequence database, designed for short reads";
    mainProgram = "screed";
    homepage = "https://pypi.org/project/screed/";
    maintainers = with lib.maintainers; [ luizirber ];
    license = lib.licenses.bsd3;
  };
}
