{ stdenv, buildEnv, ghcWithPackages, makeWrapper, ihaskell, ipython, packages }:
let
  ihaskellEnv = ghcWithPackages (self: [
    self.ihaskell
    self.ihaskell-blaze
    self.ihaskell-diagrams
    self.ihaskell-display
  ] ++ packages self);
  profile = "${ihaskell.pname}-${ihaskell.version}/profile/profile.tar";
  drv = buildEnv {
    name = "ihaskell-with-packages";
    paths = [ ihaskellEnv ipython ];
    postBuild = ''
    tar xf ${ihaskell.src} ${profile}
    mkdir -p $out/share/`dirname ${profile}`
    mkdir profile
    cd profile
    tar xf ../${profile}
    for cfg in ipython_*config.py;do
      sed -i -e "1iexe = '${ihaskell}/bin/IHaskell'" $cfg
    done
    tar cf $out/share/${profile} .
    wrapProgram "$out/bin/IHaskell" \
      --prefix PATH : "${ihaskellEnv}/bin:${ipython}/bin" \
      --set PROFILE_DIR "\$HOME/.ipython/profile_haskell" \
      --set PROFILE_TAR "$out/share/${profile}" \
      --set PROFILE_INIT "\$([ ! -d \$PROFILE_DIR ] \
          && mkdir -p \$PROFILE_DIR \
          && tar xf \$PROFILE_TAR -C \$PROFILE_DIR \
          ; [ -d \$PROFILE_DIR ] && for cfg in \$PROFILE_DIR/ipython_*config.py;do \
            sed -i -e '/.*exe.*IHaskell.*/d' \$cfg; sed -i -e \"1iexe = '${ihaskell}/bin/IHaskell'\" \$cfg;done )" \
      --set GHC_PACKAGE_PATH "\$(echo $out/lib/*/package.conf.d| tr ' ' ':'):" \
    '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })