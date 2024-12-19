{
  lib,
  asn1crypto,
  buildPythonPackage,
  certvalidator,
  fetchFromGitHub,
  mscerts,
  oscrypto,
  pyasn1,
  pyasn1-modules,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "signify";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "signify";
    rev = "refs/tags/v${version}";
    hash = "sha256-29SyzqtZ1cI+1xrSPLFr63vwB5st/9i5b3FYtJn6eok=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    asn1crypto
    certvalidator
    mscerts
    oscrypto
    pyasn1
    pyasn1-modules
    typing-extensions
  ];

  pythonImportsCheck = [ "signify" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/ralphje/signify/blob/${src.rev}/docs/changelog.rst";
    description = "library that verifies PE Authenticode-signed binaries";
    homepage = "https://github.com/ralphje/signify";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
  };
}
