{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.26";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/bK7p6xEAHLRxB6rUNjXSuiPYKi2V1xuLHgF3EYgk6o=";
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
