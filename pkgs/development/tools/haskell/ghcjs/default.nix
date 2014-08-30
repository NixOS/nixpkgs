{ nodejs, cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative
, parallel, safe, shelly, split, stringsearch, syb, systemFileio
, systemFilepath, tar, terminfo, textBinary, unorderedContainers
, vector, wlPprintText, yaml, fetchgit, Cabal, CabalGhcjs, cabalInstall
, regexPosix, alex, happy, git, gnumake, gcc, autoconf, patch
, automake, libtool, cabalInstallGhcjs, gmp, base16Bytestring
, cryptohash, executablePath, transformersCompat
, haddock, hspec, xhtml, primitive, cacert, pkgs, ghc
}:
cabal.mkDerivation (self: rec {
  pname = "ghcjs";
  version = "0.1.0";
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "fd034b7e6fb61120d22f1c314398f37a673b8b1d";
    sha256 = "0182bb706cc263a6d268eb61e243214186abae7b81dec420187c858e989c4dba";
  };
/*
  bootSrc = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "f9f79d0cf40212943bcc1ad2672f2e0a7af2b7c9";
    sha256 = "83f1706bcf7e666f6fb6dee455517e0efb019aabd1393f444c80169f04b9d3b8";
  };
*/
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "dc5bb54778f3dbba4b463f4f7df5f830f14d1cb6";
    sha256 = "fcef2879df0735b1011a8642a7c3e0e3f39b7d395830b91a992658f4ff67c9ce";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  noHaddock = true;
  haddockInternal = cabal.mkDerivation (self: {
    pname = "haddock-internal";
    version = "2.14.3";
    src = fetchgit {
      url = git://github.com/ghcjs/haddock-internal.git;
      rev = "47758773d6b20c395a1c76a93830070fde71dbab";
      sha256 = "df1a024631b7781fcbda09d2b33a56650959b8ab6c831151b456133226ab90b2";
    };
    buildDepends = [ QuickCheck ghcPaths haddock hspec xhtml ]; # Can't specify Cabal here, or it ends up being the wrong version
    doCheck = false;
  });
  ghcjsPrim = cabal.mkDerivation (self: {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "659d6ceb45b1b8ef526c7451d90afff80d76e2f5";
      sha256 = "55b64d93cdc8220042a35ea12f8c53e82f78b51bc0f87ddd12300ad56e4b7ba7";
    };
    buildDepends = [ primitive ];
  });
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib dataDefault ghcPaths hashable haskellSrcExts haskellSrcMeta
    lens optparseApplicative parallel safe shelly split
    stringsearch syb systemFileio systemFilepath tar terminfo textBinary
    unorderedContainers vector wlPprintText yaml
    alex happy git gnumake gcc autoconf automake libtool patch gmp
    base16Bytestring cryptohash executablePath haddockInternal
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
    git checkout f9f79d0cf40212943bcc1ad2672f2e0a7af2b7c9
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
