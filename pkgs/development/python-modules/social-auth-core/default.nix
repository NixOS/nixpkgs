{
  lib,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  httpretty,
  lxml,
  oauthlib,
  pyjwt,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  python-jose,
  python3-openid,
  python3-saml,
  requests,
  requests-oauthlib,
  responses,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "social-auth-core";
  version = "5.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    tag = finalAttrs.version;
    hash = "sha256-1cpVyKi/MLaABzWZiCW5yNEq49Md0NCZ+0zWUvbjlss=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    defusedxml
    oauthlib
    pyjwt
    python3-openid
    requests
    requests-oauthlib
  ];

  optional-dependencies = {
    openidconnect = [ python-jose ];
    saml = [
      lxml
      python3-saml
    ];
    azuread = [ cryptography ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    httpretty
    responses
    typing-extensions
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # missing google-auth-stubs
    "social_core/tests/backends/test_google.py"

    # network access
    "social_core/tests/backends/test_steam.py::SteamOpenIdMissingSteamIdTest::test_login"
    "social_core/tests/backends/test_steam.py::SteamOpenIdMissingSteamIdTest::test_partial_pipeline"

    # shopify is not packaged
    "social_core/tests/backends/test_shopify.py"
  ];

  pythonImportsCheck = [ "social_core" ];

  meta = {
    description = "Module for social authentication/registration mechanisms";
    homepage = "https://github.com/python-social-auth/social-core";
    changelog = "https://github.com/python-social-auth/social-core/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
