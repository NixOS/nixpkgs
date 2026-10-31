{
  lib,
  buildPythonPackage,
  cacert,
  fetchPypi,
  python,
  requests,
  flit-core,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "16.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UBYGjVSuu0PmGzw3fvRb7eTgtOsYF9ehKvgWMMVaI9I=";
  };

  build-system = [ flit-core ];

  dependencies = [
    requests
    typing-extensions
  ];

  # Tests require network connectivity and there's no easy way to disable them
  doCheck = false;

  postFixup = ''
    rm $out/${python.sitePackages}/stripe/data/ca-certificates.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/${python.sitePackages}/stripe/data/ca-certificates.crt
  '';

  pythonImportsCheck = [ "stripe" ];

  meta = {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    changelog = "https://github.com/stripe/stripe-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
