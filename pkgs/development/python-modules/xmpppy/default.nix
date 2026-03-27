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
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xmpppy";
    repo = "xmpppy";
    tag = version;
    hash = "sha256-DsASZi5eCm52gN9K59NA6Nmrwyue6ONYk/bF8khCoDs=";
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
