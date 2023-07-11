# generated with cabal2nix by ./generate.sh
{ mkDerivation, aeson, base, cmdargs, containers, data-ordlist
, directory, fetchgit, filepath, Glob, hpack, lib, parallel-io
, process, safe, text, time, yaml
}:
mkDerivation {
  pname = "ldgallery-compiler";
  version = "2.1";
  src = fetchgit {
    url = "https://github.com/pacien/ldgallery.git";
    sha256 = "184zysh5qwkbki8mn0br87h65yi5j39qwnmhz05z3ir9wfiniq4b";
    rev = "11bbbae2850b9c45da697a8ed9626495a50a38c0";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/compiler; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base cmdargs containers data-ordlist directory filepath Glob
    parallel-io process safe text time yaml
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    aeson base cmdargs containers data-ordlist directory filepath Glob
    parallel-io process safe text time yaml
  ];
  testHaskellDepends = [
    aeson base cmdargs containers data-ordlist directory filepath Glob
    parallel-io process safe text time yaml
  ];
  prePatch = "hpack";
  homepage = "https://ldgallery.pacien.org";
  description = "A static generator which turns a collection of tagged pictures into a searchable web gallery";
  license = lib.licenses.agpl3Only;
  mainProgram = "ldgallery";
  maintainers = [ lib.maintainers.pacien ];

  # Does not compile with ghc-9.2
  hydraPlatforms = lib.platforms.none;
  broken = true;
}
