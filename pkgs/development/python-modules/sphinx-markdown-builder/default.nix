{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build system
  setuptools,

  # deps
  docutils,
  sphinx,
  tabulate,

  # tests
  pytestCheckHook,
  sphinxcontrib-httpdomain,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-markdown-builder";
  version = "0.6.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = "sphinx-markdown-builder";
    tag = finalAttrs.version;
    hash = "sha256-PFGatmgQsoCCMjT3KoNmqmB77ZfdxE1tACV/8pGJmqg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    sphinx
    tabulate
  ];

  pythonImportsCheck = [ "sphinx_markdown_builder" ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinxcontrib-httpdomain
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sphinx extension to add markdown generation support";
    homepage = "https://github.com/liran-funaro/sphinx-markdown-builder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
