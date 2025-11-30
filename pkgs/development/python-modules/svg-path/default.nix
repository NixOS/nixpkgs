{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "svg.path";
  version = "7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "SVG path objects and parser";
    homepage = "https://github.com/regebro/svg.path";
    changelog = "https://github.com/regebro/svg.path/blob/${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = [ ];
  };
}
