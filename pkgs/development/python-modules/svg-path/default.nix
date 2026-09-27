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
  version = "7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "svg.path";
    tag = version;
    hash = "sha256-1dHswQLJnpOINyMub0U95FLoN/CML04sVPCm6nZBU4o=";
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
