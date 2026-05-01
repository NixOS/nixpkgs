{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  slixmpp,
  omemo,
  oldmemo,
  twomemo,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "slixmpp-omemo";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "slixmpp-omemo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UL7rIzuG33yIB+mvgcgC19cBrNobLi15bRaJjWrDNF4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    slixmpp
    omemo
    oldmemo
    twomemo
    typing-extensions
  ]
  ++ oldmemo.optional-dependencies.xml;

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  meta = {
    changelog = "https://github.com/Syndace/slixmpp-omemo/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Slixmpp plugin for the Multi-End Message and Object Encryption protocol";
    homepage = "https://github.com/Syndace/slixmpp-omemo";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ marijanp ];
  };
})
