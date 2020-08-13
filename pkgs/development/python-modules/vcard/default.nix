{ buildPythonPackage, fetchPypi, isPy27, lib, mock, python-dateutil }:

buildPythonPackage rec {
  pname = "vcard";
  version = "0.13.0";

  disabled = isPy27;

  propagatedBuildInputs = [ python-dateutil ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "bac00f830900ca983e02aa8cd8140109cea68a64bd582aece41ebd3f15dbce5a";
  };

  checkInputs =  [ mock ];
  checkPhase = "python -m unittest discover test";

  meta = with lib; {
    homepage = https://gitlab.com/victor-engmark/vcard;
    description = "vCard validator, class and utility functions";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.l0b0 ];
  };
}
