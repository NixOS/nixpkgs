{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, lxml
, pytest
, text-unidecode
, xmlschema
}:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "sepaxml";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-sepaxml";
    rev = version;
    sha256 = "1qmgdcz61hs65m2fddwn9jpyk2sxifdb0f3jz1n0lgy774z0pmas";
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
    homepage = "https://github.com/raphaelm/python-sepaxml/";
    description = "SEPA Direct Debit XML generation in python";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
