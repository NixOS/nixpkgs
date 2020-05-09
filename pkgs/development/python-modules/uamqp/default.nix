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
  version = "1.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5ac4f6e66baf466cb1c5e00d52f5da3a42bf811724522475b7e2125fbae4aae";
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
