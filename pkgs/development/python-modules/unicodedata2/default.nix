{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "unicodedata2";
  version = "18.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mikekap";
    repo = "unicodedata2";
    tag = finalAttrs.version;
    hash = "sha256-om+IJCVGuXA91RuweViW46scTX8TLa6dQeFo/pEhLzY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unicodedata2" ];

  disabledTests = [
    # Date is missing
    "test_all_names"
    "test_normalization"
  ];

  meta = {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    changelog = "https://github.com/fonttools/unicodedata2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
