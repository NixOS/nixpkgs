{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "screed";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Dk5q4fPDy0CXa7vCvn4ZGCFhZmbl94QGxAziy/0jqtc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools >= 48",' '"setuptools",' \
      --replace-fail '"setuptools_scm[toml] >= 9, <10",' '"setuptools_scm",' \
      --replace-fail '"setuptools_scm_git_archive",' ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "screed" ];

  # These tests use the screed CLI and make assumptions on how screed is
  # installed that break with nix. Can be enabled when upstream is fixed.
  disabledTests = [
    "Test_convert_shell"
    "Test_fa_shell_command"
    "Test_fq_shell_command"
  ];

  meta = {
    description = "Simple read-only sequence database, designed for short reads";
    homepage = "https://github.com/dib-lab/screed";
    changelog = "https://github.com/dib-lab/screed/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ luizirber ];
    mainProgram = "screed";
  };
})
