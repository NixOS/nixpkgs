{ lib
, buildPythonPackage
, fetchPypi
, lxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tableaudocumentapi";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g6V1UBf+P21FcZkR3PHoUmdmrQwEvjdd1VKhvNmvOys=";
  };

  propagatedBuildInputs = [ lxml ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tableaudocumentapi" ];

  # ModuleNotFoundError: No module named 'test.assets'
  doCheck = false;

  meta = with lib; {
    description = "A Python module for working with Tableau files";
    homepage = "https://github.com/tableau/document-api-python";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
