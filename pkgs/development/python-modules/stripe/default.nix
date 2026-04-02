{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  flit-core,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "14.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4+7PszaBkybNKrmpP5jrAbScTU2TydFnpSpoq5nBmog=";
  };

  build-system = [ flit-core ];

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
