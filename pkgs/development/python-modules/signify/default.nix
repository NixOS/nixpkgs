{ lib
, asn1crypto
, buildPythonPackage
, certvalidator
, fetchFromGitHub
, mscerts
, oscrypto
, pyasn1
, pyasn1-modules
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "signify";
  version = "0.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+UhZF+QYuv8pq/sTu7GDPUrlPNNixFgVZL+L0ulj/ko=";
  };

  propagatedBuildInputs = [
    asn1crypto
    certvalidator
    mscerts
    oscrypto
    pyasn1
    pyasn1-modules
  ];

  pythonImportsCheck = [
    "signify"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # chain doesn't validate because end-entitys certificate expired
    # https://github.com/ralphje/signify/issues/27
    "test_revoked_certificate"
  ];

  meta = with lib; {
    description = "library that verifies PE Authenticode-signed binaries";
    homepage = "https://github.com/ralphje/signify";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
    # No support for pyasn1 > 0.5
    # https://github.com/ralphje/signify/issues/37
    broken = true;
  };
}
