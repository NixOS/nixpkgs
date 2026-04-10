{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  setuptools,
  sphinx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-programoutput";
  version = "0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NextThought";
    repo = "sphinxcontrib-programoutput";
    tag = finalAttrs.version;
    hash = "sha256-1nWEVE4Ie6QRtm8IvSIrxYCjNtyp831teBskv63YETI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ sphinx ];

  dependencies = [ docutils ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinxcontrib.programoutput" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  disabledTests = [
    # erbsland-sphinx-ansi is not available in nixpkgs
    "test_use_ansi_enabled_extension"
  ];

  meta = {
    description = "Sphinx extension to include program output";
    homepage = "https://github.com/NextThought/sphinxcontrib-programoutput";
    changelog = "https://github.com/NextThought/sphinxcontrib-programoutput/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
