{ lib, buildPythonPackage, fetchPypi, isPy3k
, certifi
, CFNetwork
, cmake
, enum34
, openssl
, Security
, six
, stdenv
}:

buildPythonPackage rec {
  pname = "uamqp";
  version = "1.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c30b82d7569b0434415de11932c2e227d742e129593703c64178c50ceb08a7e";
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

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "An AMQP 1.0 client library for Python";
    homepage = "https://github.com/Azure/azure-uamqp-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
