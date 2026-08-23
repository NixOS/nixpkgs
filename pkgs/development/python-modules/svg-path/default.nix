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
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "svg.path";
    tag = version;
    hash = "sha256-x1u56O3HilA7Zmkrsot6Nh9E1e88qHwYnk1ySs08tbQ=";
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

  meta = {
    description = "SVG path objects and parser";
    homepage = "https://github.com/regebro/svg.path";
    changelog = "https://github.com/regebro/svg.path/blob/${version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
