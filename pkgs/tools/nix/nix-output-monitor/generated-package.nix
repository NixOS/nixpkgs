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
  version = "2.1.3";
  src = fetchzip {
    url = "https://code.maralorn.de/maralorn/nix-output-monitor/archive/v2.1.3.tar.gz";
    sha256 = "1xm40pp9lqj2hlwk3ds9zyjd4yqsis2a2ac5kn19z60glxvaijvx";
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
