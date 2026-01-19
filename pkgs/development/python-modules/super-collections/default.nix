{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hjson,
  pytestCheckHook,
  rich,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "super-collections";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "super-collections";
    tag = "v${version}";
    hash = "sha256-7QW5cL+TZlPX8ZMNNH+xZSGNIGr8Cy2jP1oSWy5tKaY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    hjson
  ];

  nativeCheckInputs = [
    pytestCheckHook
    rich
    pyyaml
  ];

  pythonImportsCheck = [
    "super_collections"
  ];

  meta = {
    description = "Python SuperDictionaries (with attributes) and SuperLists";
    homepage = "https://github.com/fralau/super-collections";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
