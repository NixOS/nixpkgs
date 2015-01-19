{ stdenv, makeWrapper, ihaskell, ipython, ghc }:

stdenv.mkDerivation rec {

  inherit (ihaskell) name pname src version meta;

  buildInputs = [ makeWrapper ];

  preferLocalBuild = true;

  buildCommand = let profile = "${pname}-${version}/profile/profile.tar"; in ''
    tar xf $src ${profile}
    mkdir -p $out/share/`dirname ${profile}`
    mkdir profile
    cd profile
    tar xf ../${profile}
    for cfg in ipython_*config.py;do
      sed -i -e "1iexe = '${ihaskell}/bin/IHaskell'" $cfg
    done
    tar cf $out/share/${profile} .
    makeWrapper "${ihaskell}/bin/IHaskell" "$out/bin/ihaskell" \
      --prefix PATH : "${ghc}/bin:${ihaskell}/bin:${ipython}/bin" \
      --prefix LD_LIBRARY_PATH : "${ihaskell}/lib/ghc-${ghc.version}/${name}/" \
      --add-flags "--ipython=${ipython}/bin/ipython" \
      --set PROFILE_DIR "\$HOME/.ipython/profile_haskell" \
      --set PROFILE_TAR "$out/share/${profile}" \
      --set PROFILE_INIT "\$([ ! -d \$PROFILE_DIR ] \
          && mkdir -p \$PROFILE_DIR \
          && tar xf \$PROFILE_TAR -C \$PROFILE_DIR \
          ; [ -d \$PROFILE_DIR ] && for cfg in \$PROFILE_DIR/ipython_*config.py;do \
            sed -i -e '/.*exe.*IHaskell.*/d' \$cfg; sed -i -e \"1iexe = '${ihaskell}/bin/IHaskell'\" \$cfg;done ) \
        " \
      --prefix GHC_PACKAGE_PATH : "\$(${ghc.GHCGetPackages} ${ghc.version}|sed -e 's, -package-db ,:,g'|cut -b 2-):${ihaskell}/lib/ghc-${ghc.version}/package.conf.d/${pname}-${version}.installedconf" \
      --set GHC_PACKAGE_PATH "\$GHC_PACKAGE_PATH:" # always end with : to include base packages
  '';
}
