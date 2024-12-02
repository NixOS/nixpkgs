{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  six,
  pycryptodomex,
  requests,
  vdf,
  gevent,
  gevent-eventemitter,
  protobuf,
  cachetools,
}:

buildPythonPackage rec {
  pname = "steam";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steam";
    rev = "refs/tags/v${version}";
    hash = "sha256-OY04GsX3KMPvpsQl8sUurzFyJu+JKpES8B0iD6Z5uyw=";
  };

  patches = [
    # https://github.com/ValvePython/steam/pull/466
    /*
      (fetchpatch {
        url = "https://github.com/ValvePython/steam/commit/e313e05d03cfbb9413cfb279a4a14fa55d0b3c4e.patch";
        hash = "sha256-y1LMwsnMXTVI8RsH07gSNQyKJfubDR+KYAkC8aHIYKw=";
      })
    */
    # TypeError: int() argument must be a string, a bytes-like object or a real number, not 'dict'
    ./whydoesthisneedfixing.patch
  ];

  build-system = [ setuptools ];
  dependencies = [
    six
    pycryptodomex
    requests
    vdf
    gevent
    protobuf
    gevent-eventemitter
    cachetools
  ];

  meta = {
    description = "Python package for interacting with Steam";
    homepage = "https://steam.readthedocs.io/en/stable/"; # setup.py links to GitHub, but GitHub links to ReadTheDocs
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
