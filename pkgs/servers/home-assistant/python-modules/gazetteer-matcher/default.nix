{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-intents,
  pytestCheckHook,
  pyyaml,
  setuptools,
  unicode-rbnf,
}:

buildPythonPackage (finalAttrs: {
  pname = "gazetteer-matcher";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "gazetteer-matcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iy5xybM8ZWlVElC2ubjxdGNj2kgKo1ZTk7Pup8e6WyY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    home-assistant-intents
    pyyaml
    unicode-rbnf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gazetteer_matcher"
  ];

  meta = {
    changelog = "https://github.com/OHF-Voice/gazetteer-matcher/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Constraint-driven intent recognizer for Home Assistant voice commands";
    homepage = "https://github.com/OHF-Voice/gazetteer-matcher";
    license = lib.licenses.asl20;
    mainProgram = "gazetteer-match";
    teams = [ lib.teams.home-assistant ];
  };
})
