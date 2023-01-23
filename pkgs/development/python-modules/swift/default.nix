{ lib
, buildPythonPackage
, fetchPypi
, boto3
, cryptography
, eventlet
, greenlet
, iana-etc
, installShellFiles
, libredirect
, lxml
, mock
, netifaces
, pastedeploy
, pbr
, pyeclib
, requests
, setuptools
, six
, stestr
, swiftclient
, xattr
}:

buildPythonPackage rec {
  pname = "swift";
  version = "2.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ytxs7hWQa7iaBinO2nhiXhNvo7lsuhmDPnqE1K62C5k=";
  };

  postPatch = ''
    # files requires boto which is incompatible with python 3.9
    rm test/functional/s3api/{__init__.py,s3_test_client.py}
  '';

  nativeBuildInputs = [
    installShellFiles
    pbr
  ];

  propagatedBuildInputs = [
    cryptography
    eventlet
    greenlet
    lxml
    netifaces
    pastedeploy
    pyeclib
    requests
    setuptools
    six
    xattr
  ];

  postInstall = ''
    installManPage doc/manpages/*
  '';

  nativeCheckInputs = [
    boto3
    mock
    stestr
    swiftclient
  ];

  # a lot of tests currently fail while establishing a connection
  doCheck = false;

  checkPhase = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so

    export SWIFT_TEST_CONFIG_FILE=test/sample.conf

    stestr run
  '';

  pythonImportsCheck = [ "swift" ];

  meta = with lib; {
    description = "OpenStack Object Storage";
    homepage = "https://github.com/openstack/swift";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
