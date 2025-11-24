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

buildPythonPackage rec {
  pname = "swift";
  version = "2.36.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3qtd++4Xm6B9TPfKvx85s71/Hz8qFrhN+XR9TuvfHXw=";
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

  meta = with lib; {
    description = "OpenStack Object Storage";
    homepage = "https://github.com/openstack/swift";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
