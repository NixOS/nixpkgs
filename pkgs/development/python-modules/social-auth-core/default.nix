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
  pytestCheckHook,
  python-jose,
  python3-openid,
  python3-saml,
  pythonOlder,
  requests,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "4.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    rev = "refs/tags/${version}";
    hash = "sha256-tFaRvNoO5K7ytqMhL//Ntasc7jb4PYXB1yyjFvFqQH8=";
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

  passthru.optional-dependencies = {
    openidconnect = [ python-jose ];
    saml = [
      lxml
      python3-saml
    ];
    azuread = [ cryptography ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    httpretty
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  # Disable checking the code coverage
  prePatch = ''
    substituteInPlace social_core/tests/requirements.txt \
      --replace "coverage>=3.6" "" \
      --replace "pytest-cov>=2.7.1" ""

    substituteInPlace tox.ini \
      --replace "{posargs:-v --cov=social_core}" "{posargs:-v}"
  '';

  pythonImportsCheck = [ "social_core" ];

  meta = with lib; {
    description = "Module for social authentication/registration mechanisms";
    homepage = "https://github.com/python-social-auth/social-core";
    changelog = "https://github.com/python-social-auth/social-core/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ n0emis ];
  };
}
