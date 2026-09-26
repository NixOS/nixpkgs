{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "sslpsk-pmd3";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "sslpsk-pmd3";
    tag = "v${version}";
    hash = "sha256-ZOPrMZhtHIpE7QMEYGti+ZjqVv93jzb74rG5Fwhjgyw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    openssl
  ];

  pythonImportsCheck = [ "sslpsk_pmd3" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    mv sslpsk_pmd3 src
  '';

  # tests are dysfunctional
  doCheck = false;

  meta = {
    changelog = "https://github.com/doronz88/sslpsk-pmd3/releases/tag/${src.tag}";
    description = "Adds TLS-PSK support to the Python ssl package";
    homepage = "https://github.com/doronz88/sslpsk-pmd3";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
