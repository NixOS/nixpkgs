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
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xmpppy";
    repo = "xmpppy";
    tag = version;
    hash = "sha256-wg7mxNHQ1+cFDLmHNafwQ2+45Jiqy36uZh28Ksu0k7Y=";
  };

  dependencies = [ six ];

  build-system = [ setuptools ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Python 2/3 implementation of XMPP";
    homepage = "https://github.com/xmpppy/xmpppy";
    changelog = "https://github.com/xmpppy/xmpppy/blob/${version}/CHANGES.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
