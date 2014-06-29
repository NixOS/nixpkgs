{ cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative_0_7_0_2
, parallel, safe, shelly, split, stringsearch, syb, systemFileio
, systemFilepath, tar, terminfo, textBinary, unorderedContainers
, vector, wlPprintText, yaml, fetchgit, Cabal, cabalInstall
, regexPosix, alex, happy, git, gnumake, gcc, autoconf, patch
, automake, libtool
}:

cabal.mkDerivation (self: rec {
  pname = "ghcjs";
  version = "c9ce6b9d";
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "c9ce6b9d87296b1236d5ef0f7d5236b2cedcff84";
    sha256 = "0cla5bchprc8g5n39fkssnv3lj378h948irsnr7dslaki6laaagw";
  };
  bootSrc = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "2daaf8fc0efd5b5906a7157a172ce77ca3b28d81";
    sha256 = "0kwn3lh196rp02kz2vxd0mkqyix99xqzs4vsazv0s49ari0dc4w8";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  noHaddock = true;
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib dataDefault ghcPaths hashable haskellSrcExts haskellSrcMeta
    lens optparseApplicative_0_7_0_2 parallel safe shelly split
    stringsearch syb systemFileio systemFilepath tar terminfo textBinary
    unorderedContainers vector wlPprintText yaml
    alex happy git gnumake gcc autoconf automake libtool patch
  ];
  testDepends = [
    HUnit regexPosix testFramework testFrameworkHunit
  ];
  postConfigure = ''
    echo Patching ghcjs with absolute paths to the Nix store
    sed -i -e "s|getAppUserDataDirectory \"ghcjs\"|return \"$out/share/ghcjs\"|" \
      src/Compiler/Info.hs
    sed -i -e "s|str = \\[\\]|str = [\"--prefix=$out\", \"--libdir=$prefix/lib/$compiler\", \"--libsubdir=$pkgid\"]|" \
      src-bin/Boot.hs
  '';
  postInstall = ''
    cp -R ${bootSrc} ghcjs-boot
    cd ghcjs-boot
    chmod -R u+w .              # because fetchgit made it read-only
    ensureDir $out/share/ghcjs
    PATH=$out/bin:${Cabal}/bin:$PATH \
      $out/bin/ghcjs-boot --init --with-cabal ${cabalInstall}/bin/cabal-js
  '';
  meta = {
    homepage = "https://github.com/ghcjs/ghcjs";
    description = "GHCJS is a Haskell to JavaScript compiler that uses the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.jwiegley ];
  };
})
