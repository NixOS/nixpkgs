# This file has been autogenerate with cabal2nix.
# Update via ./update.sh"
{ mkDerivation, ansi-terminal, async, attoparsec, base, bytestring
, cassava, containers, data-default, directory, extra, fetchzip
, filepath, hermes-json, HUnit, lib, lock-file, MemoTrie
, nix-derivation, optics, random, relude, safe, stm, streamly-core
, strict, strict-types, terminal-size, text, time, transformers
, typed-process, unix, word8
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "2.1.1";
  src = fetchzip {
    url = "https://code.maralorn.de/maralorn/nix-output-monitor/archive/v2.1.1.tar.gz";
    sha256 = "1k1gdx7yczz7xm096i8lk09zq6yw1yj8izx6czymfd4qqwj2y49l";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal async attoparsec base bytestring cassava containers
    data-default directory extra filepath hermes-json lock-file
    MemoTrie nix-derivation optics relude safe stm streamly-core strict
    strict-types terminal-size text time transformers word8
  ];
  executableHaskellDepends = [
    ansi-terminal async attoparsec base bytestring cassava containers
    data-default directory extra filepath hermes-json lock-file
    MemoTrie nix-derivation optics relude safe stm streamly-core strict
    strict-types terminal-size text time transformers typed-process
    unix word8
  ];
  testHaskellDepends = [
    ansi-terminal async attoparsec base bytestring cassava containers
    data-default directory extra filepath hermes-json HUnit lock-file
    MemoTrie nix-derivation optics random relude safe stm streamly-core
    strict strict-types terminal-size text time transformers
    typed-process word8
  ];
  homepage = "https://github.com/maralorn/nix-output-monitor";
  description = "Processes output of Nix commands to show helpful and pretty information";
  license = lib.licenses.agpl3Plus;
  mainProgram = "nom";
  maintainers = [ lib.maintainers.maralorn ];
}
