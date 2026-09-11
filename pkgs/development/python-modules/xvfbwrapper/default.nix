{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xvfb,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xvfbwrapper";
  version = "0.2.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgoldberg";
    repo = "xvfbwrapper";
    tag = version;
    sha256 = "sha256-iqWDXDzoGAs6Ze1XHrM3HzeqTHbiYU2/CpeZQNzwl0s=";
  };

  build-system = [ setuptools ];

  dependencies = [ xvfb ];

  nativeCheckInputs = [
    pytestCheckHook
    xvfb
  ];

  meta = {
    description = "Run headless displays inside X virtual framebuffers (Xvfb)";
    homepage = "https://github.com/cgoldberg/xvfbwrapper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
