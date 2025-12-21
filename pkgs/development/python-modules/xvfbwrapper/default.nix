{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xorg,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xvfbwrapper";
  version = "0.2.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgoldberg";
    repo = "xvfbwrapper";
    tag = version;
    sha256 = "sha256-2ExEhqq1XMjGniRII5qw4fj2cDqYjTa4BjKNYo6ZJCw=";
  };

  build-system = [ setuptools ];

  dependencies = [ xorg.xvfb ];

  nativeCheckInputs = [
    pytestCheckHook
    xorg.xvfb
  ];

  meta = {
    description = "Run headless displays inside X virtual framebuffers (Xvfb)";
    homepage = "https://github.com/cgoldberg/xvfbwrapper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
