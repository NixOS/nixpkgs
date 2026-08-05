{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  breame,

  # tests
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uwotm8";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "i-dot-ai";
    repo = "uwotm8";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6kbdsx3ZywuHaQUEYnj/Z4DWsu1VdAGOhf1emFh4tZk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    breame
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [
    "uwotm8"
  ];

  meta = {
    description = "Tool for converting American English to British English in text and code files";
    homepage = "https://github.com/i-dot-ai/uwotm8";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
    mainProgram = "uwotm8";
  };
})
