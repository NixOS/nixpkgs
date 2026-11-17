{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  sphinx,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "sphinx-llms-txt";
  version = "0.7.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdillard";
    repo = "sphinx-llms-txt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9uj5UYl6/TppGd3zuGUpxiY9U6/65ffWDPKaX7ut4zg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    sphinx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinx_llms_txt" ];

  meta = {
    description = "llms.txt generator for Sphinx";
    homepage = "https://github.com/jdillard/sphinx-llms-txt";
    changelog = "https://github.com/jdillard/sphinx-llms-txt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
