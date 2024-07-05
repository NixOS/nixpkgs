{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "9.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xC2Pa0RjpU86AlWBgQ9OYy4tWnHeYQD8WV11WB9ppJI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  # Tests require network connectivity and there's no easy way to disable them
  doCheck = false;

  pythonImportsCheck = [ "stripe" ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    changelog = "https://github.com/stripe/stripe-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
