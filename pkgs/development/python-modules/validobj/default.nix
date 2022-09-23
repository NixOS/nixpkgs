{ lib
, buildPythonPackage
, fetchPypi
, flit
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "validobj";
  version = "0.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BvnHn0Erk87Ce3tYwYf0tBwRJMrG19Af/Y568VJ02uo=";
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
