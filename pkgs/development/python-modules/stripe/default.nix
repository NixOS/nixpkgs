{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "14.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nHB8sFA+F5wtnxhzHpTxMzcFtc2dyq5pLbCZla0o1BE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  # Tests require network connectivity and there's no easy way to disable them
  doCheck = false;

  pythonImportsCheck = [ "stripe" ];

  meta = {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    changelog = "https://github.com/stripe/stripe-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
