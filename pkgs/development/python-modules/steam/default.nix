{
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  fetchpatch,
  gevent,
  gevent-eventemitter,
  lib,
  protobuf,
  pycryptodomex,
  requests,
  setuptools,
  six,
  vdf,
}:
buildPythonPackage rec {
  pname = "steam";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steam";
    rev = "refs/tags/v${version}";
    hash = "sha256-OY04GsX3KMPvpsQl8sUurzFyJu+JKpES8B0iD6Z5uyw=";
  };

  patches = [
    # Fixes upstream bug.
    #
    # https://github.com/ValvePython/steam/pull/437
    (fetchpatch {
      url = "https://github.com/ValvePython/steam/commit/783f023236b2686afbcd2ad124051dc51c20aff0.patch";
      hash = "sha256-9p52Kjc1TWmFLMr7dMuU6n1MeVC8g0G6hYNgERbMoAM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    gevent
    gevent-eventemitter
    protobuf
    pycryptodomex
    requests
    six
    vdf
  ];

  pythonImportsCheck = [ "steam" ];

  meta = {
    description = "A Python package for interacting with Steam";
    homepage = "https://github.com/ValvePython/steam";
    changelog = "https://github.com/ValvePython/steam/blob/master/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jackwilsdon ];
  };
}
