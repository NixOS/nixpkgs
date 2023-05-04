{ lib
, buildPythonPackage
, cryptography
, defusedxml
, fetchFromGitHub
, httpretty
, lxml
, oauthlib
, pyjwt
, pytestCheckHook
, python-jose
, python3-openid
, python3-saml
, pythonOlder
, requests
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "4.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    rev = "refs/tags/${version}";
    hash = "sha256-1uRQ+7dPaD7X0GnI4rCaXJNmkc2uE/OLdxy3T7Gg3Bg=";
  };

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
    openidconnect = [
      python-jose
    ];
    saml = [
      lxml
      python3-saml
    ];
    azuread = [
      cryptography
    ];
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

  pythonImportsCheck = [
    "social_core"
  ];

  meta = with lib; {
    description = "Module for social authentication/registration mechanisms";
    homepage = "https://github.com/python-social-auth/social-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ n0emis ];
  };
}
