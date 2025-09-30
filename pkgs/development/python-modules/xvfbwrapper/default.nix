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
  version = "0.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgoldberg";
    repo = "xvfbwrapper";
    tag = version;
    sha256 = "sha256-SLf9ytogbIXPM/Nf5h6akKhU3UnAAspJc5f9/bL5YNk=";
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
