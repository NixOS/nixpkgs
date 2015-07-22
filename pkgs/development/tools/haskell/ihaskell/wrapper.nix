{ stdenv, writeScriptBin, buildEnv, ghcWithPackages, ihaskell, ipython, packages }:
let
  ihaskellEnv = ghcWithPackages (self: [
    self.ihaskell
    self.ihaskell-blaze
    self.ihaskell-diagrams
    self.ihaskell-display
  ] ++ packages self);
  ihaskellSh = writeScriptBin "ihaskell-notebook" ''
    #! ${stdenv.shell}
    export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export PATH="${ihaskell}/bin:${ihaskellEnv}/bin:${ipython}/bin"
    ${ihaskell}/bin/ihaskell install -l $(${ihaskellEnv}/bin/ghc --print-libdir) && ${ipython}/bin/ipython notebook --kernel=haskell
  '';
  profile = "${ihaskell.pname}-${ihaskell.version}/profile/profile.tar";
in
buildEnv {
  name = "ihaskell-with-packages";
  paths = [ ihaskellEnv ipython ];
  postBuild = ''
    ln -s ${ihaskellSh}/bin/ihaskell-notebook $out/bin/.
  '';
}
