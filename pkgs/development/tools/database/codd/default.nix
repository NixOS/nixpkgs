{
  lib,
  haskell,
  mkDerivation,
  fetchFromGitHub,
  haskellPackages,
}:

let

  # Haxl has relatively tight version requirements and is thus marked as broken.
  haxlJailbroken = haskell.lib.markUnbroken (haskell.lib.doJailbreak haskellPackages.haxl);
in

mkDerivation rec {
  pname = "codd";

  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "mzabani";
    repo = "codd";
    rev = "refs/tags/v${version}";
    hash = "sha256-hFAo0DLhxULeib3OMjfTYBQIBJ5+apWlMDGsK5gUwho=";
  };

  isLibrary = false;

  isExecutable = true;

  libraryHaskellDepends = with haskellPackages; [
    aeson
    aeson-pretty
    ansi-terminal
    attoparsec
    base
    bytestring
    clock
    containers
    dlist
    filepath
    formatting
    hashable
    haxlJailbroken
    mtl
    network-uri
    postgresql-libpq
    postgresql-simple
    resourcet
    streaming
    text
    time
    transformers
    unliftio
    unliftio-core
    unordered-containers
    vector
  ];

  executableHaskellDepends = with haskellPackages; [
    base
    optparse-applicative
    postgresql-simple
    text
    time
  ];

  testHaskellDepends = with haskellPackages; [
    aeson
    attoparsec
    base
    containers
    hashable
    hspec
    hspec-core
    mtl
    network-uri
    postgresql-simple
    QuickCheck
    random
    resourcet
    streaming
    text
    time
    typed-process
    unliftio
  ];

  # We only run codd's tests that don't require postgresql nor strace. We need to support unix sockets in codd's test suite
  # before enabling postgresql's tests, and SystemResourcesSpecs might fail on macOS because of the need for strace and parsing
  # libc calls. Not that we really gain much from running SystemResourcesSpecs here anyway.
  testFlags = [
    "--skip"
    "/DbDependentSpecs/"
    "--skip"
    "/SystemResourcesSpecs/"
  ];

  description = "CLI tool that applies plain postgres SQL migrations atomically with strong and automatic cross-environment schema equality checks";

  mainProgram = "codd";

  homepage = "https://github.com/mzabani/codd";

  changelog = "https://github.com/mzabani/codd/releases/tag/v${version}";

  license = lib.licenses.bsd3;

  maintainers = with lib.maintainers; [ mzabani ];
}
