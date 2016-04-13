# Haste requires its own patched up version of cabal-install that's not on hackage
{ mkDerivation, array, base, bytestring, Cabal, containers
, directory, extensible-exceptions, filepath, HTTP, mtl, network
, network-uri, pretty, process, QuickCheck, random, regex-posix
, stdenv, stm, tagged, tasty, tasty-hunit, tasty-quickcheck, time
, unix, zlib
, fetchFromGitHub
}:

mkDerivation {
  pname = "cabal-install";
  version = "1.23.0.0";
  src = fetchFromGitHub {
    owner = "valderman";
    repo = "cabal";
    rev = "a1962987ba32d5e20090830f50c6afdc78dae005";
    sha256 = "1gjmscfsikcvgkv6zricpfxvj23wxahndm784lg9cpxrc3pn5hvh";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    array base bytestring Cabal containers directory filepath HTTP mtl
    network network-uri pretty process random stm time unix zlib
  ];
  testHaskellDepends = [
    array base bytestring Cabal containers directory
    extensible-exceptions filepath HTTP mtl network network-uri pretty
    process QuickCheck random regex-posix stm tagged tasty tasty-hunit
    tasty-quickcheck time unix zlib
  ];
  prePatch = ''
    rm -rf Cabal
    cd cabal-install
  '';
  postInstall = ''
    mkdir $out/etc
    mv bash-completion $out/etc/bash_completion.d

    # Manually added by Nix maintainer
    mv -v $out/etc/bash_completion.d/cabal $out/etc/bash_completion.d/haste-cabal
  '';
  doCheck = false;
  homepage = "http://www.haskell.org/cabal/";
  description = "The command-line interface for Cabal and Hackage";
  license = stdenv.lib.licenses.bsd3;
}
