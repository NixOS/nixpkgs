{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "standard-imghdr";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/imghdr";

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/youknowone/python-deadlib";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    description = "Standard library imghdr redistribution";
    license = lib.licenses.psfl;
  };
}
