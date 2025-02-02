{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  six,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xmpppy";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xmpppy";
    repo = "xmpppy";
    rev = "refs/tags/${version}";
    hash = "sha256-SnzIjEWSCdiCtD8bmPTH02JprmZhrABB4HCqtt2RBuk=";
  };

  dependencies = [ six ];

  build-system = [ setuptools ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Python 2/3 implementation of XMPP";
    homepage = "https://github.com/xmpppy/xmpppy";
    changelog = "https://github.com/xmpppy/xmpppy/blob/${version}/CHANGES.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jopejoe1 ];
  };
}
