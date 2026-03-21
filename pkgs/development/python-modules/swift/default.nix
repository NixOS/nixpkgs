{
  lib,
  buildPythonPackage,
  fetchPypi,
  boto3,
  cryptography,
  eventlet,
  greenlet,
  iana-etc,
  installShellFiles,
  libredirect,
  lxml,
  mock,
  pastedeploy,
  pbr,
  pyeclib,
  requests,
  setuptools,
  six,
  stestr,
  swiftclient,
  xattr,
}:

buildPythonPackage (finalAttrs: {
  pname = "swift";
  version = "2.37.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-EO50/6S6fXIZtYsCAO8VmpWotKdwgnmY48W6XKCypGU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cryptography
    eventlet
    greenlet
    lxml
    pastedeploy
    pyeclib
    requests
    six
    xattr
  ];

  nativeCheckInputs = [
    boto3
    libredirect.hook
    mock
    stestr
    swiftclient
  ];

  postInstall = ''
    installManPage doc/manpages/*
  '';

  # a lot of tests currently fail while establishing a connection
  doCheck = false;

  checkPhase = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)

    export SWIFT_TEST_CONFIG_FILE=test/sample.conf

    stestr run
  '';

  pythonImportsCheck = [ "swift" ];

  meta = {
    description = "OpenStack Object Storage";
    homepage = "https://github.com/openstack/swift";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
