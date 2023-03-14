{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, asn1crypto
, certvalidator
, oscrypto
, pyasn1
, pyasn1-modules
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "signify";
  version = "0.4.0";
  disabled = pythonOlder "3.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YJc9RIqkEL7dd1ahE4IbxyyZgsZWBDqbXZAvI/nK24M=";
  };

  propagatedBuildInputs = [
    asn1crypto
    certvalidator
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
    homepage = "https://github.com/ralphje/signify";
    description = "library that verifies PE Authenticode-signed binaries";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
  };
}
