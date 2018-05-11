{ lib, buildPythonPackage, fetchPypi, cryptography, pytest, pyopenssl, service-identity }:

buildPythonPackage rec {
  pname = "trustme";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1215vr6l6c0fzsv5gyay82fxd4fidvq2rd94wvjrljs6h2wajazk";
  };

  checkInputs = [ pytest pyopenssl service-identity ];
  checkPhase = ''
    py.test
  '';
  propagatedBuildInputs = [
    cryptography
  ];

  meta = {
    description = "#1 quality TLS certs while you wait, for the discerning tester";
    homepage = https://github.com/python-trio/trustme;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
