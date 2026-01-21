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

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "4.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    tag = version;
    hash = "sha256-8UDJfn1NDNHM8PBTV6n18GFSmOUqXo8UGbrJLFfLlnY=";
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
    pytest-xdist
    pytestCheckHook
    httpretty
    responses
    typing-extensions
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # missing google-auth-stubs
    "social_core/tests/backends/test_google.py"

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
