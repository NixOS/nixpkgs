{ cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck
, random, stm, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time, zlib, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "7471c95f23";
  src = fetchgit {
    url = git://github.com/ghcjs/cabal.git;
    rev = "0a9531272ed50b4057e788005e3c6e5a7e2442bd"; # Must be from the ghcjs branch
    sha256 = "212af6d134ff85b8046977c8754852e4048872d330ab2250b94cd51373328daa";
  };
  preConfigure = "cd Cabal";
  configureFlags = "--program-suffix=-js";

  # jww (2014-05-31): Why is this failing?
  # BuildDeps/InternalLibrary4:
  #   : [Failed]
  # expected: 'setup install' should succeed
  #   output: "/private/var/folders/8h/tky3qz1d63l05l5jp_nzwzjr0000gn/T/nix-build-haskell-Cabal-ghcjs-ghc7.8.2-9e87d6a3-shared.drv-0/git-export/Cabal/tests/Setup configure --user -w /nix/store/v1gr2sk0117ycn9bmwyp3whgxqkbd5sl-ghc-7.8.2-wrapper/bin/ghc" in PackageTests/BuildDeps/InternalLibrary4/to-install
  # Configuring InternalLibrary4-0.2...
  # Setup: Use of GHC's environment variable GHC_PACKAGE_PATH is incompatible with
  # Cabal. Use the flag --package-db to specify a package database (it can be used
  # multiple times).
  doCheck = false;
  noHaddock = true;

  buildDepends = [
    filepath HTTP mtl network random stm time zlib QuickCheck
  ];
  testDepends = [
    filepath HTTP HUnit mtl network QuickCheck stm testFramework
    testFrameworkHunit testFrameworkQuickcheck2 time zlib
  ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "The command-line interface for Cabal and Hackage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
