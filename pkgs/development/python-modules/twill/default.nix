{ lib, buildPythonPackage, fetchPypi, isPy3k, nose }:
buildPythonPackage rec {
  pname = "twill";
  version = "1.8.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d63e8b09aa4f6645571c70cd3ba47a911abbae4d7baa4b38fc7eb72f6cfda188";
  };

  checkInputs = [ nose ];

  doCheck = false; # pypi package comes without tests, other homepage does not provide all verisons

  meta = with lib; {
    homepage = http://twill.idyll.org/;
    description = "A simple scripting language for Web browsing";
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
