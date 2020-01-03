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
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0f96a21b430cc29661644d3569a1112a397ca9cc8595b964d4ae71e5e957529";
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
