{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.28";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kCgGouCCH69BITBFC9u4TxXplqcpBhpR/nKGxiC2/uM=";
  };

  pythonImportsCheck = [ "striprtf" ];

  meta = with lib; {
    changelog = "https://github.com/joshy/striprtf/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/joshy/striprtf";
    description = "Simple library to convert rtf to text";
    mainProgram = "striprtf";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
  };
}
