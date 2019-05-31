{ lib, buildPythonPackage, fetchPypi, isPy3k, cryptography, futures, pytest, pyopenssl, service-identity }:

buildPythonPackage rec {
  pname = "trustme";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d12837c6242afe1660dee08d44d96f40c9a5074cc58caf39f8c8fdf4b526529";
  };

  checkInputs = [ pytest pyopenssl service-identity ];
  checkPhase = ''
    py.test
  '';
  propagatedBuildInputs = [
    cryptography
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  meta = {
    description = "#1 quality TLS certs while you wait, for the discerning tester";
    homepage = https://github.com/python-trio/trustme;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
