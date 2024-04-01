{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "shortuuid";
  version = "1.0.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w58bNIs8HpsRWpVLM7dsjFItLRd6nSCs27INJPrDzP0=";
  };

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "shortuuid"
  ];

  meta = with lib; {
    description = "Library to generate concise, unambiguous and URL-safe UUIDs";
    mainProgram = "shortuuid";
    homepage = "https://github.com/stochastic-technologies/shortuuid/";
    changelog = "https://github.com/skorokithakis/shortuuid/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zagy ];
  };
}
