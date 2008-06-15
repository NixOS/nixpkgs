# idea: provide nix environment for your developement actions
# experimental

/*
  # example: 
  # add postgresql to environment and create ctags (tagfiles can be extracted from TAG_FILES)
  # add this to your ~/.nixpkgs/config.nix

 devEnvs = pkgs : with pkgs; with sourceAndTags;
  let simple = { name, buildInputs ? [], cTags ? [] }:
          pkgs.myEnvFun {
            inherit name stdenv;
          buildInputs = buildInputs 
                ++ map (x : sourceWithTagsDerivation ( (addCTaggingInfo x ).passthru.sourceWithTags ) ) cTags;
          extraCmds = ". ~/.bashrc; cd $PWD
            # configure should find them
            export LDFLAGS=$NIX_LDFLAGS
            export CFLAGS=$NIX_CFLAGS_COMPILE
            ";
          preBuild = "export TAG_FILES";
        };
  in {
    postgresql = simple {
     name = "postgresql";
     buildInputs = [postgresql];
     cTags = [postgresql ];
    };
  };

  Put this into your .bashrc
    loadEnv(){ . "${HOME}/.nix-profile/dev-envs/${1}" }
  then install and 
    $ loadEnv postgresql

*/

args: args.stdenv.mkDerivation ( 
  { extraCmds =""; } // {
  phases = "buildPhase";
  buildPhase = '' 
    eval "$preBuild"
    name=${args.name}
    o=$out/dev-envs/$name
    ensureDir `dirname $o`
    echo "
    OLDPATH=\$PATH " >> $o
    export | grep -v HOME= | grep -v PATH= | grep -v PWD= | grep -v TEMP= | grep -v TMP= >> $o 
    echo "
    PATH=$PATH:$OLDPATH
    for i in \$buildInputs; do
      export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$i/lib
    done
    export PATH=\$PATH:\$OLDPATH
    $extraCmds
    echo env $name loaded
    " >> $o
  '';
} // args // { name = "${args.name}-env"; } )
