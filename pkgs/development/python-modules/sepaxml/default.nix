{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, lxml, pytestCheckHook
, text-unidecode, xmlschema }:

buildPythonPackage rec {
  pname = "sepaxml";
  version = "2.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-sepaxml";
    rev = version;
    sha256 = "sha256-Up6zHm20tc6+lQk958csdgC4FMJFhdt+oAJcNcVbcjk=";
  };

  propagatedBuildInputs = [ text-unidecode xmlschema ];

  checkInputs = [ pytestCheckHook lxml ];

  pythonImportsCheck = [ "sepaxml" ];

  meta = with lib; {
    description = "SEPA Direct Debit XML generation in python";
    homepage = "https://github.com/raphaelm/python-sepaxml/";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
