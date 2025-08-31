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
  version = "0.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgoldberg";
    repo = "xvfbwrapper";
    tag = version;
    sha256 = "sha256-8JO5NMRawqFmGEmjeVed8dd9b2JD/n547rM9fp7A8L8=";
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
