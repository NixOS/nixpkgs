{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "svg.path";
  version = "6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "svg.path";
    tag = version;
    hash = "sha256-qes6cKw/Ok0WgcPO/NPuREVNUbnlhm82jF90dK7Ay8U=";
  };

  build-system = [ setuptools ];

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
    changelog = "https://github.com/regebro/svg.path/blob/${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = [ ];
  };
}
