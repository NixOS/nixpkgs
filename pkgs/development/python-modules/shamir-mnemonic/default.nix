{ lib, fetchPypi, buildPythonPackage, isPy3k, click, colorama }:

buildPythonPackage rec {
  pname = "shamir-mnemonic";
  version = "0.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cc08d276e05b13cd32bd3b0c5d1cb6c30254e0086e0f6857ec106d4cceff121";
  };

  propagatedBuildInputs = [ click colorama ];

  meta = with lib; {
    description = "Reference implementation of SLIP-0039";
    homepage = "https://github.com/trezor/python-shamir-mnemonic";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers."1000101" ];
  };
}
