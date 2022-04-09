# This file has been autogenerate with cabal2nix.
# Update via ./update.sh"
{
  mkDerivation,
  ansi-terminal,
  async,
  attoparsec,
  base,
  bytestring,
  cassava,
  containers,
  data-default,
  directory,
  extra,
  fetchzip,
  filepath,
  generic-optics,
  HUnit,
  lib,
  lock-file,
  MemoTrie,
  mtl,
  nix-derivation,
  optics,
  process,
  random,
  relude,
  safe,
  stm,
  streamly,
  terminal-size,
  text,
  time,
  unix,
  vector,
  wcwidth,
  word8,
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "1.1.3.0";
  src = fetchzip {
    url = "https://github.com/maralorn/nix-output-monitor/archive/refs/tags/v1.1.3.0.tar.gz";
    sha256 = "085phr84m0b056mj3c09gzcwv7b1wax7nhsg2qscahfz0q8f4ym7";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    data-default
    directory
    extra
    filepath
    generic-optics
    lock-file
    MemoTrie
    mtl
    nix-derivation
    optics
    random
    relude
    safe
    stm
    streamly
    terminal-size
    text
    time
    unix
    vector
    wcwidth
    word8
  ];
  executableHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    data-default
    directory
    extra
    filepath
    generic-optics
    lock-file
    MemoTrie
    mtl
    nix-derivation
    optics
    random
    relude
    safe
    stm
    streamly
    terminal-size
    text
    time
    unix
    vector
    wcwidth
    word8
  ];
  testHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    data-default
    directory
    extra
    filepath
    generic-optics
    HUnit
    lock-file
    MemoTrie
    mtl
    nix-derivation
    optics
    process
    random
    relude
    safe
    stm
    streamly
    terminal-size
    text
    time
    unix
    vector
    wcwidth
    word8
  ];
  homepage = "https://github.com/maralorn/nix-output-monitor";
  description = "Parses output of nix-build to show additional information";
  license = lib.licenses.agpl3Plus;
  maintainers = with lib.maintainers; [maralorn];
}
