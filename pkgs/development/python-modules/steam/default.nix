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
}:
let
  version = "1.4.4";
  hash = "sha256-OY04GsX3KMPvpsQl8sUurzFyJu+JKpES8B0iD6Z5uyw=";
in
buildPythonPackage rec {
  pname = "steam";
  inherit version;

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steam";
    tag = "v${version}";
    inherit hash;
  };

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
