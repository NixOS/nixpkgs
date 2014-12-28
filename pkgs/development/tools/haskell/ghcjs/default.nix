{ nodejs, cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative
, parallel, safe, shelly, split, stringsearch, syb, systemFileio
, systemFilepath, tar, terminfo, textBinary, unorderedContainers
, vector, wlPprintText, yaml, fetchgit, Cabal, cabalInstall
, regexPosix, alex, happy, git, gnumake, gcc, autoconf, patch
, automake, libtool, gmp, base16Bytestring
, cryptohash, executablePath, transformersCompat, haddockApi
, haddock, hspec, xhtml, primitive, cacert, pkgs, ghc
, coreutils
, ghcjsPrim
}:
let
  version = "0.1.0";
  libDir = "share/ghcjs/${pkgs.stdenv.system}-${version}-${ghc.ghc.version}/ghcjs";
  ghcjsBoot = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "5c7a71472d5a797e895914d3b82cea447a058793";
    sha256 = "0dp97bgbnlr3sd9yfnk27p6dfv46fi26sn6y6qv1wxs5i29kmjav";
  };
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "7e15b992b538298c0da1de73e202d950a279cbfb";
    sha256 = "0ck7qwizrjxh9mjfqcaw083sjlwhd1kvgvdcp3plzh7g2kd1lmzn";
  };
in cabal.mkDerivation (self: rec {
  pname = "ghcjs";
  inherit version;
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "312a040d579133b4e251ac375e5f94e506c1a981";
    sha256 = "0c3bjaz2wwi8lxmxp9bajyhcs97aazgzfgm1fc8mggk94nr4fhrk";
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
    PATH=$out/bin:${Cabal}/bin:$PATH LD_LIBRARY_PATH=${gmp}/lib:${gcc.gcc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot \
        --dev \
        --with-cabal ${cabalInstall}/bin/cabal \
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
