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

buildPythonPackage (finalAttrs: {
  pname = "social-auth-core";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    tag = finalAttrs.version;
    hash = "sha256-4Z08ZHTSPSNG9x9XZWwGuvKYk3UnogLm5pO/MHWN0CE=";
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
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
