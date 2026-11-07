{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  setuptools,
  wheel,
  # Dependencies
  markdown-it-py,
  # Tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "slackify-markdown";
  version = "0.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thesmallstar";
    repo = "slackify-markdown-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w5oldcu0oVvZe/dEfm2rdeSwU38K27EAUme1gCZA3ak=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    markdown-it-py
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [
    "slackify_markdown"
  ];
  enabledTestPaths = [
    "tests/"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert Markdown to Slack compatible markdown";
    homepage = "https://github.com/thesmallstar/slackify-markdown-python";
    changelog = "https://github.com/thesmallstar/slackify-markdown-python/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
