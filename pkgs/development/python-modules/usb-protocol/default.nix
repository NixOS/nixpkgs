{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  construct,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "usb-protocol";
  version = "0.9.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "python-usb-protocol";
    rev = "refs/tags/${version}";
    hash = "sha256-CYbXs/SRC1FAVEzfw0gwf6U0qQ9Q34nyuj5yfjHfDn8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [ construct ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "usb_protocol"
  ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/python-usb-protocol/releases/tag/${version}";
    description = "Python library providing utilities, data structures, constants, parsers, and tools for working with the USB protocol";
    homepage = "https://github.com/greatscottgadgets/python-usb-protocol";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
