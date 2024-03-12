{ lib
, asn1crypto
, buildPythonPackage
, certvalidator
, fetchFromGitHub
, fetchpatch2
, mscerts
, oscrypto
, pyasn1
, pyasn1-modules
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "signify";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "signify";
    rev = "refs/tags/v${version}";
    hash = "sha256-+UhZF+QYuv8pq/sTu7GDPUrlPNNixFgVZL+L0ulj/ko=";
  };

  patches = [
    # https://github.com/ralphje/signify/pull/42
    (fetchpatch2 {
      url = "https://github.com/ralphje/signify/commit/38cad57bf86f7498259b47bfef1354aec27c0955.patch";
      hash = "sha256-dLmHSlj2Cj6jbbrZStgK2Rh/H5vOaIbi5lut5RAbd+s=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

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

  meta = with lib; {
    changelog = "https://github.com/ralphje/signify/blob/${src.rev}/docs/changelog.rst";
    description = "library that verifies PE Authenticode-signed binaries";
    homepage = "https://github.com/ralphje/signify";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
  };
}
