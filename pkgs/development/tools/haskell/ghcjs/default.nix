{ nodejs, cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative
, parallel, safe, shelly, split, stringsearch, syb, systemFileio
, systemFilepath, tar, terminfo, textBinary, unorderedContainers
, vector, wlPprintText, yaml, fetchgit, Cabal, CabalGhcjs, cabalInstall
, regexPosix, alex, happy, git, gnumake, gcc, autoconf, patch
, automake, libtool, cabalInstallGhcjs, gmp, base16Bytestring
, cryptohash, executablePath, transformersCompat, haddockApi
, haddock, hspec, xhtml, primitive, cacert, pkgs, ghc
, coreutils
}:
let
  version = "0.1.0";
  libDir = "share/ghcjs/${pkgs.stdenv.system}-${version}-${ghc.ghc.version}/ghcjs";
  ghcjsBoot = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "28f328ae5acb7427483ee1aaca66a4ed2df38472";
    sha256 = "107sqpadbjqxs3ym23qbp141ihra0a8ijaar94dbpa69g8b0xyyl"; # no .git
  };
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "5e11d33cb74f8522efca0ace8365c0dc994b10f6";
    sha256 = "13i78wd064v0nvvx6js5wqw6s01hhf1s7z03c4465xp64a817gk4";
  };
  # TOD: move this into haskell-packages proper
  ghcjsPrim = cabal.mkDerivation (self: {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "8e003e1a1df10233bc3f03d7bbd7d37de13d2a84";
      sha256 = "11k2r87s58wmpxykn61lihn4vm3x67cm1dygvdl26papifinj6pz";
    };
    buildDepends = [ primitive ];
  });
in cabal.mkDerivation (self: rec {
  pname = "ghcjs";
  inherit version;
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "fa0cc146b2fbdac28136fdca621e95930e2fd035";
    sha256 = "1mvs4x0x1cv11m32n5kjil3q1jxszj6capshvgz3a7mzdm5cdqp8";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  noHaddock = true;
  doCheck = false;
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib dataDefault ghcPaths hashable haskellSrcExts haskellSrcMeta
    lens optparseApplicative parallel safe shelly split
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
  patches = [ ./ghcjs.patch ];
  postPatch = ''
    substituteInPlace Setup.hs --replace "/usr/bin/env" "${coreutils}/bin/env"
    substituteInPlace src/Compiler/Info.hs --replace "@PREFIX@" "$out"
    substituteInPlace src-bin/Boot.hs --replace "@PREFIX@" "$out"
  '';
  preBuild = ''
    local topDir=$out/${libDir}
    mkdir -p $topDir

    cp -r ${ghcjsBoot} $topDir/ghcjs-boot
    chmod -R u+w $topDir/ghcjs-boot

    cp -r ${shims} $topDir/shims
    chmod -R u+w $topDir/shims
  '';
  postInstall = ''
    PATH=$out/bin:${CabalGhcjs}/bin:$PATH LD_LIBRARY_PATH=${gmp}/lib:${gcc.gcc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot \
        --dev \
        --with-cabal ${cabalInstallGhcjs}/bin/cabal-js \
        --with-gmp-includes ${gmp}/include \
        --with-gmp-libraries ${gmp}/lib
  '';
  passthru = {
    inherit libDir;
  };
  meta = {
    homepage = "https://github.com/ghcjs/ghcjs";
    description = "GHCJS is a Haskell to JavaScript compiler that uses the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.jwiegley ];
  };
})
