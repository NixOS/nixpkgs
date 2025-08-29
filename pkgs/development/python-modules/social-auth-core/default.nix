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
  pythonOlder,
  requests,
  requests-oauthlib,
  responses,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    tag = version;
    hash = "sha256-PQPnLTTCAUE1UmaDRmEXLozY0607e2/fLsvzcJzo4bQ=";
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
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTestPaths = [
    # missing google-auth-stubs
    "social_core/tests/backends/test_google.py"

    # network access
    "social_core/tests/backends/test_steam.py::SteamOpenIdMissingSteamIdTest::test_login"
    "social_core/tests/backends/test_steam.py::SteamOpenIdMissingSteamIdTest::test_partial_pipeline"
  ];

  pythonImportsCheck = [ "social_core" ];

  meta = with lib; {
    description = "Module for social authentication/registration mechanisms";
    homepage = "https://github.com/python-social-auth/social-core";
    changelog = "https://github.com/python-social-auth/social-core/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
