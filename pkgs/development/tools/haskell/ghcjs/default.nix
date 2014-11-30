{ nodejs, cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative_0_9_1_1
, parallel, safe, shelly, split, stringsearch, syb, systemFileio
, systemFilepath, tar, terminfo, textBinary, unorderedContainers
, vector, wlPprintText, yaml, fetchgit, Cabal, CabalGhcjs, cabalInstall
, regexPosix, alex, happy, git, gnumake, gcc, autoconf, patch
, automake, libtool, cabalInstallGhcjs, gmp, base16Bytestring
, cryptohash, executablePath, transformersCompat, haddockApi
, haddock, hspec, xhtml, primitive, cacert, pkgs, ghc
}:
cabal.mkDerivation (self: rec {
  pname = "ghcjs";
  version = "0.1.0";
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "5c2d279982466e076223fcbe1e1096e22956e5a9";
    sha256 = "0bc37b4e8bd039208a126fea39850c99459265cb273ac7237939cdbaee6ef71f";
  };
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "5e11d33cb74f8522efca0ace8365c0dc994b10f6";
    sha256 = "64be139022e6f662086103fca3838330006d38e6454bd3f7b66013031a47278e";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  noHaddock = true;
  doCheck = false;
  ghcjsPrim = cabal.mkDerivation (self: {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "915f263c06b7f4a246c6e02ecdf2b9a0550ed967";
      sha256 = "34dd58b6e2d0ce780da46b509fc2701c28a7b2182f8d700b53a80981ac8bcf86";
    };
    buildDepends = [ primitive ];
  });
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib dataDefault ghcPaths hashable haskellSrcExts haskellSrcMeta
    lens optparseApplicative_0_9_1_1 parallel safe shelly split
    stringsearch syb systemFileio systemFilepath tar terminfo textBinary
    unorderedContainers vector wlPprintText yaml
    alex happy git gnumake gcc autoconf automake libtool patch gmp
    base16Bytestring cryptohash executablePath haddockApi
    transformersCompat QuickCheck haddock hspec xhtml
    ghcjsPrim regexPosix
  ];
  buildTools = [ nodejs git ];
  testDepends = [
    HUnit testFramework testFrameworkHunit
  ];
  postConfigure = ''
    echo Patching ghcjs with absolute paths to the Nix store
    sed -i -e "s|getAppUserDataDirectory \"ghcjs\"|return \"$out/share/ghcjs\"|" \
      src/Compiler/Info.hs
    sed -i -e "s|str = \\[\\]|str = [\"--prefix=$out\", \"--libdir=$prefix/lib/$compiler\", \"--libsubdir=$pkgid\"]|" \
      src-bin/Boot.hs
  '';
  libdir = "/share/ghcjs/${pkgs.stdenv.system}-${version}-${ghc.ghc.version}";
  postInstall = ''
    export HOME=$(pwd)
    export GIT_SSL_CAINFO="${cacert}/etc/ca-bundle.crt"
    git clone git://github.com/ghcjs/ghcjs-boot.git
    cd ghcjs-boot
    git checkout f5e57f9d4d8241a78ebdbdb34262921782a27e1a
    git submodule update --init --recursive
    ( cd boot ; chmod u+w . ; ln -s .. ghcjs-boot )
    chmod -R u+w .              # because fetchgit made it read-only
    local GHCJS_LIBDIR=$out${libdir}
    ensureDir $GHCJS_LIBDIR
    cp -R ${shims} $GHCJS_LIBDIR/shims
    ${cabalInstallGhcjs}/bin/cabal-js update
    PATH=$out/bin:${CabalGhcjs}/bin:$PATH LD_LIBRARY_PATH=${gmp}/lib:${gcc.gcc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot --dev --with-cabal ${cabalInstallGhcjs}/bin/cabal-js --with-gmp-includes ${gmp}/include --with-gmp-libraries ${gmp}/lib
  '';
  meta = {
    homepage = "https://github.com/ghcjs/ghcjs";
    description = "GHCJS is a Haskell to JavaScript compiler that uses the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.jwiegley ];
  };
})
