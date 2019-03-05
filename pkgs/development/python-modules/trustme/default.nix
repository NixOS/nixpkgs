{ lib, buildPythonPackage, fetchPypi, isPy3k, cryptography, futures, pytest, pyopenssl, service-identity }:

buildPythonPackage rec {
  pname = "trustme";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89b8d689013afeaa34b63e77f6d60eebad63edc4b247e744c7d6d891ed13a564";
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
