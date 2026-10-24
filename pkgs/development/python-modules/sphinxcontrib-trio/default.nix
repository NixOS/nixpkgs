{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  sphinx,
  pytestCheckHook,
  lxml,
  cssselect,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-trio";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nxupwdWWW1NOhSWNi2d92U6bGpoukYuFzNQlkFlrR8A=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
    sphinx
    cssselect
  ];

  disabledTests = [ "test_end_to_end" ];

  pythonImportsCheck = [ "sphinxcontrib_trio" ];

  meta = with lib; {
    description = "Make Sphinx better at documenting Python functions and methods";
    homepage = "https://pypi.org/project/sphinxcontrib-trio/";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ laggron42 ];
  };
}
