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
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wmyw2l2pha5s6khih96lkfa90zyfy2mqsg8cx6vplmrmpx2s52i";
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
    homepage = https://github.com/Azure/azure-uamqp-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
