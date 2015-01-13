{ stdenv, makeWrapper, ihaskell, ipython, ghc }:

stdenv.mkDerivation rec {

  inherit (ihaskell) name;

  buildInputs = [ makeWrapper ];

  preferLocalBuild = true;

  buildCommand = ''
    makeWrapper "${ihaskell}/bin/IHaskell" "$out/bin/ihaskell" \
      --prefix PATH : "${ghc}/bin:${ihaskell}/bin:${ipython}/bin" \
      --prefix LD_LIBRARY_PATH : "${ihaskell}/lib/ghc-${ghc.version}/${name}/" \
      --add-flags "--ipython=${ipython}/bin/ipython" \
      --set PROFILE_DIR "\$HOME/.ipython/profile_haskell" \
      --set PROFILE_TAR "$(find ${ihaskell} -iname "profile.tar")" \
      --set PROFILE_INIT "\$([ ! -d \$PROFILE_DIR ] && mkdir -p \$PROFILE_DIR && tar xvf \$PROFILE_TAR -C \$PROFILE_DIR)" \
      --prefix GHC_PACKAGE_PATH : "\$(${ghc.GHCGetPackages} ${ghc.version}|sed -e 's, -package-db ,:,g'|cut -b 2-):${ihaskell}/lib/ghc-${ghc.version}/package.conf.d/${name}.installedconf" \
      --set GHC_PACKAGE_PATH "\$GHC_PACKAGE_PATH:" # always end with : to include base packages
  '';

  inherit (ihaskell) meta;
}
