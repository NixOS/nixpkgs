{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  six,
  pycryptodomex,
  requests,
  urllib3,
  vdf,
  gevent,
  protobuf,
  gevent-eventemitter,
  cachetools,
  setuptools,
}:
buildPythonPackage rec {
  pname = "steam";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steam";
    rev = "v${version}";
    hash = "sha256-OY04GsX3KMPvpsQl8sUurzFyJu+JKpES8B0iD6Z5uyw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    pycryptodomex
    requests
    urllib3
    vdf
    gevent
    protobuf
    gevent-eventemitter
    cachetools
  ];

  meta = {
    description = "Python package for interacting with Steam";
    homepage = "https://github.com/ValvePython/steam";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ weirdrock ];
  };
}
