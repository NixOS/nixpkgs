{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, cryptography
, futures
, pytest
, pyopenssl
, service-identity
, idna
}:

buildPythonPackage rec {
  pname = "trustme";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9dfb18b568729d0219f758cddca1a91bab59f62ca41ee0e8acce5e657ec97b6c";
  };

  checkInputs = [
    pytest
    pyopenssl
    service-identity
  ];

  propagatedBuildInputs = [
    cryptography
    idna
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  checkPhase = ''
    pytest
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "High quality TLS certs while you wait, for the discerning tester";
    homepage = https://github.com/python-trio/trustme;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
