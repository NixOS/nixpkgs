{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, lxml
, pytest
, text-unidecode
, xmlschema
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "sepaxml";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-sepaxml";
    rev = version;
    sha256 = "0lkb0nnyxmwvm6gkwls8w2290b66lwz9bv8p39wwcn7flabviwhj";
  };

  propagatedBuildInputs = [
    text-unidecode
    xmlschema
  ];

  checkInputs = [ pytest lxml ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/raphaelm/python-sepaxml/;
    description = "SEPA Direct Debit XML generation in python";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
