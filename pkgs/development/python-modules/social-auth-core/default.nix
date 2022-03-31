{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, oauthlib
, requests_oauthlib
, pyjwt
, cryptography
, defusedxml
, python3-openid
, python-jose
, python3-saml
, pytestCheckHook
, httpretty
}:

buildPythonPackage rec {
  pname = "social-auth-core";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "python-social-auth";
    repo = "social-core";
    rev = version;
    sha256 = "sha256-kaL6sfAyQlzxszCEbhW7sns/mcOv0U+QgplmUd6oegQ=";
  };

  # Disable checking the code coverage
  prePatch = ''
    substituteInPlace social_core/tests/requirements.txt \
      --replace "coverage>=3.6" "" \
      --replace "pytest-cov>=2.7.1" ""

    substituteInPlace tox.ini \
      --replace "{posargs:-v --cov=social_core}" "{posargs:-v}"
  '';

  propagatedBuildInputs = [
    requests
    oauthlib
    requests_oauthlib
    pyjwt
    cryptography
    defusedxml
    python3-openid
    python-jose
    python3-saml
  ];

  checkInputs = [
    pytestCheckHook
    httpretty
  ];

  pythonImportsCheck = [ "social_core" ];

  meta = with lib; {
    homepage = "https://github.com/python-social-auth/social-core";
    description = "Python Social Auth - Core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ n0emis ];
  };
}
