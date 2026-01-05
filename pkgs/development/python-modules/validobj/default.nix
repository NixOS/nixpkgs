{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "validobj";
  version = "1.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tab3n3YGTcGk47Ijm/QOocT0zo10LJp4eEF094TJyzg=";
  };

  nativeBuildInputs = [ flit ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "validobj" ];

  meta = with lib; {
    description = "Validobj is library that takes semistructured data (for example JSON and YAML configuration files) and converts it to more structured Python objects";
    homepage = "https://github.com/Zaharid/validobj";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
