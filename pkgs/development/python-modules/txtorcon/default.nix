{
  lib,
  stdenv,
  automat,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  geoip,
  lsof,
  mock,
  pytestCheckHook,
  setuptools,
  twisted,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "24.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vv4ZE42cjFMHtu5tT+RG0MIB/9HMQErrJl7ZAwmXitA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    twisted
    automat
    zope-interface
  ]
  ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    pytestCheckHook
    mock
    lsof
    geoip
  ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  pythonImportsCheck = [ "txtorcon" ];

  meta = {
    description = "Twisted-based Tor controller client, with state-tracking and configuration abstractions";
    homepage = "https://github.com/meejah/txtorcon";
    changelog = "https://github.com/meejah/txtorcon/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      jluttine
      exarkun
    ];
    license = lib.licenses.mit;
  };
}
