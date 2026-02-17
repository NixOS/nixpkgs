{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  hatchling,
  idna,
  pyopenssl,
  pytestCheckHook,
  service-identity,
}:

buildPythonPackage rec {
  pname = "trustme";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZSi6K7x/LbQfM4JcjdE+Pj650zS6D5CXE8jDE59K5H8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    idna
  ];

  nativeCheckInputs = [
    pyopenssl
    pytestCheckHook
    service-identity
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "trustme" ];

  meta = {
    description = "High quality TLS certs while you wait, for the discerning tester";
    homepage = "https://github.com/python-trio/trustme";
    changelog = "https://trustme.readthedocs.io/en/latest/#change-history";
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
}
