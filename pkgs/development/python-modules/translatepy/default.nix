{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  beautifulsoup4,
  pyuseragents,
  safeio,
  inquirer,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "translatepy";
  version = "2.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Animenosekai";
    repo = "translate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cx5OeBrB8il8KrcyOmQbQ7VCXoaA5RP++oTTxCs/PcM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    beautifulsoup4
    pyuseragents
    safeio
    inquirer
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    # Requires network connection
    "tests/test_translate.py"
    "tests/test_translators.py"
  ];
  pythonImportsCheck = [ "translatepy" ];

  meta = {
    description = "Module grouping multiple translation APIs";
    mainProgram = "translatepy";
    homepage = "https://github.com/Animenosekai/translate";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
})
