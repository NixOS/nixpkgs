{ lib
, buildPythonPackage
, fetchPypi
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "svg.path";
  version = "6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GiFZ+duJjfk8RjfP08yvfaH9Bz9Z+ppZUMc+RtSqGso=";
  };

  checkInputs = [
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # generated image differs from example
    "test_image"
  ];

  pythonImportsCheck = [
    "svg.path"
  ];

  meta = with lib; {
    description = "SVG path objects and parser";
    homepage = "https://github.com/regebro/svg.path";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
  };
}
