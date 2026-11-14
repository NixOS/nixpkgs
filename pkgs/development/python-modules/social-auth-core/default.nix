{
  lib,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  httpretty,
  oauthlib,
  pyjwt,
  python3-openid,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  google-auth,
  python3-saml,
  requests,
  requests-oauthlib,
  responses,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    tag = version;
    hash = "sha256-HIRqueDoT5MiK5wYto1/MhZOJVBGUdsHma/klOyVHtM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    defusedxml
    oauthlib
    pyjwt
    python3-openid
    requests
    requests-oauthlib
  ]
  ++ pyjwt.optional-dependencies.crypto;

  optional-dependencies = {
    google-onetap = [ google-auth ];
    saml = [
      python3-saml
    ];
    # shopify = [ shopifyapi];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    httpretty
    responses
    typing-extensions
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # network access
    "test_invalid_signature"
  ];
  disabledTestPaths = [
    # network access
    "social_core/tests/backends/test_steam.py::SteamOpenIdMissingSteamIdTest::test_login"
    "social_core/tests/backends/test_steam.py::SteamOpenIdMissingSteamIdTest::test_partial_pipeline"
  ];

  pythonImportsCheck = [ "social_core" ];

  meta = {
    description = "Module for social authentication/registration mechanisms";
    homepage = "https://github.com/python-social-auth/social-core";
    changelog = "https://github.com/python-social-auth/social-core/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
