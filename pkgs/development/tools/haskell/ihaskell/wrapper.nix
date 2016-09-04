{ stdenv, writeScriptBin, makeWrapper, buildEnv, ghcWithPackages, ihaskell, ipython, packages }:
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
    export PATH="${stdenv.lib.makeBinPath [ ihaskell ihaskellEnv ipython ]}"
    ${ihaskell}/bin/ihaskell install -l $(${ihaskellEnv}/bin/ghc --print-libdir) && ${ipython}/bin/ipython notebook --kernel=haskell
  '';
  profile = "${ihaskell.pname}-${ihaskell.version}/profile/profile.tar";
in
buildEnv {
  name = "ihaskell-with-packages";
  paths = [ ihaskellEnv ipython ];
  postBuild = ''
    . "${makeWrapper}/nix-support/setup-hook"
    ln -s ${ihaskellSh}/bin/ihaskell-notebook $out/bin/.
    for prg in $out/bin"/"*;do
      wrapProgram $prg --set PYTHONPATH "$(echo ${ipython}/lib/*/site-packages)"
    done
  '';
}
