{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  stestrCheckHook,
  swiftclient,
  xattr,
}:

buildPythonPackage (finalAttrs: {
  pname = "swift";
  version = "2.38.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "swift";
    tag = finalAttrs.version;
    hash = "sha256-EzG3P6If2Rjj6ufEbOQFKe8LOterWef+C1xRJEwM4tg=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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
    stestrCheckHook
    swiftclient
  ];

  postInstall = ''
    installManPage doc/manpages/*
  '';

  # a lot of tests currently fail while establishing a connection
  doCheck = false;

  preCheck = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)

    export SWIFT_TEST_CONFIG_FILE=test/sample.conf
  '';

  pythonImportsCheck = [ "swift" ];

  meta = {
    description = "OpenStack Object Storage";
    homepage = "https://github.com/openstack/swift";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
