{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pillow,
}:

buildPythonPackage rec {
  pname = "python-sixel";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lubosz";
    repo = "python-sixel";
    tag = version;
    hash = "sha256-ALNdwuZIMS2oWO42LpjgIpAxcQh4Gk35nCwenINLQ64=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pillow
  ];

  pythonImportsCheck = [
    "sixel"
  ];

  meta = {
    description = "Display images in the terminal";
    homepage = "https://github.com/lubosz/python-sixel";
    changelog = "https://github.com/lubosz/python-sixel/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ atemu ];
  };
}
