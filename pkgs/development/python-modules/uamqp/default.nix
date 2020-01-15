{ CFNetwork
, Security
, buildPythonPackage
, certifi
, cmake
, enum34
, fetchPypi
, isPy3k
, lib
, openssl
, stdenv
, six
}:

buildPythonPackage rec {
  pname = "uamqp";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3d4ff94bf290adb82fe8c19af709a21294bac9b27c821b9110165a34b922015";
  };

  buildInputs = [
    openssl
    certifi
    six
  ] ++ lib.optionals (!isPy3k) [
    enum34
  ] ++ lib.optionals stdenv.isDarwin [
    CFNetwork Security
  ];

  nativeBuildInputs = [
    cmake
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "An AMQP 1.0 client library for Python";
    homepage = https://github.com/Azure/azure-uamqp-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
