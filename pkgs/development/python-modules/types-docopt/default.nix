{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-docopt";
  version = "0.6.11.20241107";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YcRNA6xIlbW+jUC6XMgM5Spj09dnd60UZp6Utent96c=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "docopt-stubs" ];

  meta = {
    description = "Typing stubs for docopt";
    homepage = "https://pypi.org/project/types-docopt/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
