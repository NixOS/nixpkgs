{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "svg.path";
  version = "6.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6Td0CjFqf+yGrNIXq2Im4RL1EygHhSQSa7fqnb57Gt4=";
  };

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # generated image differs from example
    "test_image"
  ];

  pythonImportsCheck = [ "svg.path" ];

  meta = with lib; {
    description = "SVG path objects and parser";
    homepage = "https://github.com/regebro/svg.path";
    license = licenses.mit;
    maintainers = [ ];
  };
}
