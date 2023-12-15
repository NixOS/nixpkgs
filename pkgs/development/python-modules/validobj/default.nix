{ lib
, buildPythonPackage
, fetchPypi
, flit
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "validobj";
  version = "1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CISX8pycEOYUBolyMoJqaKdE0u/8tf7mvbHYm9m148I=";
  };

  nativeBuildInputs = [ flit ];

  nativeCheckInputs = [ hypothesis pytestCheckHook ];

  pythonImportsCheck = [ "validobj" ];

  meta = with lib; {
    description = "Validobj is library that takes semistructured data (for example JSON and YAML configuration files) and converts it to more structured Python objects";
    homepage = "https://github.com/Zaharid/validobj";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
