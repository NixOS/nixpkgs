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
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d15cb12d61a6481f7de412c2d53a99f87650e0d1e5394b047aeee5514964fb8";
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
