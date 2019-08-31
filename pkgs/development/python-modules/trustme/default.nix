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
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "103f8n0c60593r0z8hh1zvk1bagxwnhrv3203xpiiddwqxalr04b";
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

  meta = {
    description = "High quality TLS certs while you wait, for the discerning tester";
    homepage = https://github.com/python-trio/trustme;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
