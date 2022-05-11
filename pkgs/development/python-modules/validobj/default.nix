{ lib
, buildPythonPackage
, fetchPypi
, flit
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "validobj";
  version = "0.5.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "430b0b56931a2cebdb857a9fe9da2467c06a3b4db37b728e7f1a8706e8887705";
  };

  nativeBuildInputs = [ flit ];

  checkInputs = [ hypothesis pytestCheckHook ];

  pythonImportsCheck = [ "validobj" ];

  meta = with lib; {
    description = "Validobj is library that takes semistructured data (for example JSON and YAML configuration files) and converts it to more structured Python objects";
    homepage = "https://github.com/Zaharid/validobj";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
