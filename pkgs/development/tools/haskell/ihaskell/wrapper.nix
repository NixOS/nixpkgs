{ lib, stdenv, writeScriptBin, makeWrapper, buildEnv, haskell, ghcWithPackages, jupyter, packages }:
let
  ihaskellEnv = ghcWithPackages (self: [
    self.ihaskell
    self.ihaskell-blaze
    self.ihaskell-diagrams
  ] ++ packages self);
  ihaskellSh = writeScriptBin "ihaskell-notebook" ''
    #! ${stdenv.shell}
    export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export PATH="${lib.makeBinPath ([ ihaskellEnv jupyter ])}''${PATH:+:}$PATH"
    ${ihaskellEnv}/bin/ihaskell install -l $(${ihaskellEnv}/bin/ghc --print-libdir) && ${jupyter}/bin/jupyter notebook
  '';
in
buildEnv {
  name = "ihaskell-with-packages";
  nativeBuildInputs = [ makeWrapper ];
  paths = [ ihaskellEnv jupyter ];
  postBuild = ''
    ln -s ${ihaskellSh}/bin/ihaskell-notebook $out/bin/
    for prg in $out/bin"/"*;do
      if [[ -f $prg && -x $prg ]]; then
        wrapProgram $prg --set PYTHONPATH "$(echo ${jupyter}/lib/*/site-packages)"
      fi
    done
  '';
  meta = {
    # ihaskell has an indirect dependency on the Python package mistune, which
    # is marked insecure.
    hydraPlatforms = lib.platforms.none;
  };
}
