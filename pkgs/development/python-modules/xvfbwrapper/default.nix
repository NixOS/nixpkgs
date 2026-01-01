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
<<<<<<< HEAD
  version = "0.2.16";
=======
  version = "0.2.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgoldberg";
    repo = "xvfbwrapper";
    tag = version;
<<<<<<< HEAD
    sha256 = "sha256-2ExEhqq1XMjGniRII5qw4fj2cDqYjTa4BjKNYo6ZJCw=";
=======
    sha256 = "sha256-9PDLR8oz6VcRfqWOrLCw08wCqJeNCI5leiE6+QZi7xY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
