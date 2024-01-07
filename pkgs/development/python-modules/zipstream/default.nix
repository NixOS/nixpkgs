{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "zipstream";
  version = "1.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01im5anqdyggmwkigqcjg0qw2a5bnn84h33mfaqjjd69a28lpwif";
  };

  nativeCheckInputs = [ nose ];

  meta = {
    description = "A zip archive generator";
    homepage = "https://github.com/allanlei/python-zipstream";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
