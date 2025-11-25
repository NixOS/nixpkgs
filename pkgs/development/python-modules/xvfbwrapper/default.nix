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
  version = "0.2.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgoldberg";
    repo = "xvfbwrapper";
    tag = version;
    sha256 = "sha256-9PDLR8oz6VcRfqWOrLCw08wCqJeNCI5leiE6+QZi7xY=";
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
