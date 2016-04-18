# Haste requires its own patched up version of Cabal that's not on hackage
{ mkDerivation, array, base, binary, bytestring, containers
, deepseq, directory, extensible-exceptions, filepath, old-time
, pretty, process, QuickCheck, regex-posix, stdenv, tasty
, tasty-hunit, tasty-quickcheck, time, unix
, fetchFromGitHub
}:

mkDerivation {
  pname = "Cabal";
  version = "1.23.0.0";
  src = fetchFromGitHub {
    owner = "valderman";
    repo = "cabal";
    rev = "a1962987ba32d5e20090830f50c6afdc78dae005";
    sha256 = "1gjmscfsikcvgkv6zricpfxvj23wxahndm784lg9cpxrc3pn5hvh";
  };
  libraryHaskellDepends = [
    array base binary bytestring containers deepseq directory filepath
      pretty process time unix
  ];
  testHaskellDepends = [
    base bytestring containers directory extensible-exceptions filepath
      old-time pretty process QuickCheck regex-posix tasty tasty-hunit
      tasty-quickcheck unix
  ];
  prePatch = ''
    rm -rf cabal-install
    cd Cabal
    '';
  doCheck = false;
  homepage = "http://www.haskell.org/cabal/";
  description = "A framework for packaging Haskell software";
  license = stdenv.lib.licenses.bsd3;
}
