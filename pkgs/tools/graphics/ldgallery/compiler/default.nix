# generated with cabal2nix by ./generate.sh
{ mkDerivation, aeson, base, cmdargs, containers, data-ordlist
, directory, fetchgit, filepath, Glob, hpack, parallel-io, process
, safe, lib, text, time, yaml
}:
mkDerivation {
  pname = "ldgallery-compiler";
  version = "2.0";
  src = fetchgit {
    url = "https://github.com/pacien/ldgallery.git";
    sha256 = "1a82wy6ns1434gdba2l04crvr5waf03y02bappcxqci2cfb1cznz";
    rev = "e93f7b1eb84c083d67567115284c0002a3a7d5fc";
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
  license = lib.licenses.agpl3;
  maintainers = with lib.maintainers; [ pacien ];
}
